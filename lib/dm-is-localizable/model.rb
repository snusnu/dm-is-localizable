module DataMapper
  module I18n
    module Model

      def translatable(options = {}, &block)
        @i18n = Proxy.new(self, options, &block)
        self
      end

      def is_localizable(options = {}, &block)
        warn "#{self}.is_localizable is deprecated, use #{self}.translatable instead (#{caller[2]})"
        translatable(options, &block)
      end

      module API
        # the proxy instance to delegate api calls to
        attr_reader :i18n
      end # module API

      class Proxy

        attr_reader :translated_model
        attr_reader :translation_model
        attr_reader :configuration

        def initialize(translated_model, options, &block)
          @translated_model  = translated_model
          @configuration     = Configuration.new(@translated_model, options)

          # locals are cheap, formatting ftw!
          name      = @configuration.translation_model_name
          namespace = @configuration.translation_model_namespace

          @translation_model = DataMapper::Model.new(name, namespace) do
            property :id, DataMapper::Property::Serial
          end

          @translatable_properties = {}

          instance_eval &block # capture @translatable properties

          # define translatable properties on @translation_model
          @translatable_properties.each do |name, args|
            @translation_model.property name, *args
          end

          Integrator.integrate(self)

          @translated_model.class_eval do
            extend  I18n::Model::API
            include I18n::Resource::API
          end
        end

        # list all available locales for the localizable model
        def available_locales
          tags = translation_model.all.map { |t| t.locale_tag }.uniq
          tags.any? ? DataMapper::I18n::Locale.all(:tag => tags) : []
        end

        def translatable_properties
          translation_model.properties.select { |property| @translatable_properties.key?(property.name) }
        end

      private

        def property(name, type, options = {})
          @translatable_properties[name] = [ type, options ]
        end

        class Configuration

          attr_reader :options
          attr_reader :translated_model
          attr_reader :translated_model_fk_name
          attr_reader :translated_model_belongs_to_name
          attr_reader :translation_model_name
          attr_reader :translation_model_namespace
          attr_reader :translations

          def initialize(translated_model, options)
            @translated_model                 = translated_model
            translated_model_name             = DataMapper::Inflector.demodulize(translated_model.name)
            @options                          = default_options.merge(options)
            @translated_model_fk_name         = DataMapper::Inflector.foreign_key(translated_model_name).to_sym
            @translated_model_belongs_to_name = DataMapper::Inflector.underscore(translated_model_name).to_sym
            @translation_model_name           = DataMapper::Inflector.demodulize(@options[:model].to_s)
            @translation_model_namespace      = @options[:namespace]
            @translations                     = DataMapper::Inflector.tableize(@translation_model_name).to_sym
            @accepts_nested_attributes        = @options[:accepts_nested_attributes]

            require 'dm-accepts_nested_attributes' if @accepts_nested_attributes
          end

          def default_options
            {
              :namespace => default_translation_model_namespace,
              :model     => "#{translated_model}Translation",
              :accept_nested_attributes => DataMapper::I18n.accepts_nested_attributes?
            }
          end

          def default_translation_model_namespace
            DataMapper::I18n.translation_model_namespace || DataMapper::Ext::Object.namespace(translated_model)
          end

          def accepts_nested_attributes?
            @accepts_nested_attributes
          end

        end # class Configuration

        class Integrator

          def self.integrate(translation_proxy)
            new(translation_proxy).integrate
          end

          attr_reader :proxy
          attr_reader :translated_model
          attr_reader :translation_model
          attr_reader :configuration

          def initialize(proxy)
            @proxy             = proxy
            @translated_model  = @proxy.translated_model
            @translation_model = @proxy.translation_model
            @configuration     = @proxy.configuration
          end

          def integrate
            establish_relationships
            establish_validations
            generate_relationship_alias
            generate_property_readers

            if configuration.accepts_nested_attributes?
              generate_nested_attribute_accessors
            end

            self
          end

        private

          def establish_relationships
            translation_model.belongs_to configuration.translated_model_belongs_to_name,
              :repository   => translated_model.repository.name,
              :unique_index => :unique_locales

            translation_model.belongs_to :locale, DataMapper::I18n::Locale,
              :repository   => DataMapper::I18n.locale_repository_name,
              :unique_index => :unique_locales

            translated_model.has n, configuration.translations, translation_model,
              { :repository => translation_model.repository.name }.merge!(
              DataMapper.const_defined?('Constraints') ?
              { :constraint => :destroy! }             :
              {})

            translated_model.has n, :locales, DataMapper::I18n::Locale,
              :repository   => DataMapper::I18n.locale_repository_name,
              :through      => configuration.translations

            self
          end

          def establish_validations
            translation_model.validates_uniqueness_of :locale_tag, :scope => configuration.translated_model_fk_name
          end

          def generate_relationship_alias
            # make that available in #class_eval
            translations_relationship = configuration.translations

            translated_model.class_eval do
              alias_method :translations, translations_relationship
            end

            self
          end

          def generate_property_readers
            proxy.translatable_properties.each do |property|
              translated_model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{property.name}(locale_tag = DataMapper::I18n.default_locale_tag)
                  i18n.translate(:#{property.name}, DataMapper::I18n.normalized_locale_tag(locale_tag))
                end
              RUBY
            end
            self
          end

          def generate_nested_attribute_accessors
            # make those available in #class_eval
            translations_relationship = configuration.translations
            translations_attributes   = :"#{translations_relationship}_attributes"

            translated_model.class_eval do
              accepts_nested_attributes_for translations_relationship
              alias_method :translations_attributes, translations_attributes
            end

            self
          end

          def n
            Infinity
          end

        end # class Integrator
      end # classProxy
    end # module Model
  end # module I18n
end # module DataMapper
