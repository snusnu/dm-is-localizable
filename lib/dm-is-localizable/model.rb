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
          @translated_model = translated_model
          @configuration    = Configuration.new(@translated_model, options)

          # locals are cheap, formatting ftw!
          name      = @configuration.translation_model_name
          namespace = @configuration.translation_model_namespace

          @translation_model = DataMapper::Model.new(name, namespace) do
            property :id, DataMapper::Property::Serial
          end

          @translatable_properties = {}
          @timestamps = false

          instance_eval &block # capture @translatable properties

          # define translatable properties on @translation_model
          @translatable_properties.each do |name, args|
            @translation_model.property name, *args
          end

          @translation_model.timestamps(@timestamps) if @timestamps

          Integrator.integrate(self)

          @translated_model.class_eval do
            extend  I18n::Model::API
            include I18n::Resource::API
          end
        end

        # list all available locales for the localizable model
        def available_locales
          translation_model.all(:fields => [:locale_tag], :unique => true).map { |t| t.locale }
        end

        def translatable_properties
          translation_model.properties.select { |property| @translatable_properties.key?(property.name) }
        end

      private

        def property(name, type, options = {})
          @translatable_properties[name] = [ type, options ]
        end

        def timestamps(kind)
          @timestamps = kind
        end

        class Configuration

          attr_reader :options
          attr_reader :translated_model
          attr_reader :translated_model_name
          attr_reader :translated_model_belongs_to_name
          attr_reader :translation_model_name
          attr_reader :translation_model_namespace
          attr_reader :translation_model_fk
          attr_reader :translations

          def initialize(translated_model, options)
            @translated_model                 = translated_model
            @translated_model_name            = DataMapper::Inflector.underscore(DataMapper::Inflector.demodulize(translated_model.name))
            @translated_model_belongs_to_name = @translated_model_name.to_sym
            @options                          = default_options.merge(options)
            @translation_model_name           = DataMapper::Inflector.demodulize(@options[:model].to_s)
            @translation_model_namespace      = @options[:namespace]
            @translations                     = DataMapper::Inflector.tableize(@translation_model_name).to_sym
            @accepts_nested_attributes        = @options[:accepts_nested_attributes] || DataMapper::I18n.accepts_nested_attributes?

            @translation_model_fk = translated_model.key.map do |property|
              "#{@translated_model_name}_#{property.name}"
            end

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

            source_key = []
            target_key = []
            fk_options = { :required => true, :unique_index => :locales }

            # setup the (composite) foreign key properties
            translated_model.key.each do |property|
              fk_attribute_name    = "#{configuration.translated_model_name}_#{property.name}"
              fk_attribute_options = property.serial? ? fk_options.merge(:min => 1) : fk_options
              source_key << fk_attribute_name
              target_key << property.name
              translation_model.property fk_attribute_name, property.to_child_key, fk_attribute_options
            end

            # workaround a bug in dm-core that excludes :unique_index from propagating
            # down from DataMapper::Model#belongs_to to DataMapper::Model#property
            translation_model.property :locale_tag, String, fk_options

            translation_model.belongs_to configuration.translated_model_belongs_to_name,
              :repository => translated_model.repository.name,
              :child_key  => source_key,
              :parent_key => target_key

            translation_model.belongs_to :locale, DataMapper::I18n::Locale,
              :repository => DataMapper::I18n.locale_repository_name

            translated_model.has n, configuration.translations, translation_model,
              { :repository => translation_model.repository.name }.merge!(
              DataMapper.const_defined?('Constraints') ?
              { :constraint => :destroy! }             :
              {})

            translated_model.has n, :locales, DataMapper::I18n::Locale,
              :repository => DataMapper::I18n.locale_repository_name,
              :through    => configuration.translations

            self
          end

          def establish_validations
            translation_model.validates_uniqueness_of :locale_tag, :scope => configuration.translation_model_fk
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
              alias_method :translations_attributes,     translations_attributes
              alias_method :translations_attributes=, "#{translations_attributes}="
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
