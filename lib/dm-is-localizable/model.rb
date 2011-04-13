module DataMapper
  module I18n
    module Model

      def translatable(options = {}, &block)
        @i18n = TranslationProxy.new(self, options, &block)
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

      class TranslationProxy

        attr_reader :translated_model
        attr_reader :translation_model
        attr_reader :configuration

        def initialize(translated_model, options, &block)
          @translated_model  = translated_model
          @configuration     = Configuration.new(@translated_model, options)

          # locals are cheap, formatting ftw!
          translation_model_name      = @configuration.translation_model_name
          translation_model_namespace = @configuration.translation_model_namespace

          @translation_model = DataMapper::Model.new(translation_model_name, translation_model_namespace) do
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
          ids = translation_model.all.map { |t| t.locale_id }.uniq
          ids.any? ? DataMapper::I18n::Locale.all(:id => ids) : []
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
          attr_reader :translated_model_fk
          attr_reader :translated_model_name
          attr_reader :translation_model_name
          attr_reader :translation_model_namespace
          attr_reader :translations

          def initialize(translated_model, options)
            @translated_model            = translated_model
            @options                     = default_options.merge(options)
            fk_string                    = DataMapper::Inflector.foreign_key(@translated_model.name)
            @translated_model_fk         = fk_string.to_sym
            @translated_model_name       = fk_string[0, fk_string.rindex('_id')].to_sym
            @translation_model_name      = DataMapper::Inflector.demodulize(@options[:model].to_s)
            @translation_model_namespace = @options[:namespace]
            @translations                = DataMapper::Inflector.tableize(@translation_model_name).to_sym
            @nested_accessors            = @options[:accepts_nested_attributes]
          end

          def nested_accessors?
            @nested_accessors
          end

          def default_options
            {
              :namespace => default_translation_model_namespace,
              :model     => "#{translated_model}Translation",
              :accept_nested_attributes => true
            }
          end

          def default_translation_model_namespace
            DataMapper::I18n.translation_model_namespace || DataMapper::Ext::Object.namespace(translated_model)
          end

        end # class Configuration

        class Integrator

          def self.integrate(translation_proxy)
            new(translation_proxy).integrate
          end

          attr_reader :translation_proxy
          attr_reader :translated_model
          attr_reader :translation_model
          attr_reader :configuration

          def initialize(translation_proxy)
            @translation_proxy = translation_proxy
            @translated_model  = @translation_proxy.translated_model
            @translation_model = @translation_proxy.translation_model
            @configuration     = @translation_proxy.configuration
          end

          def integrate
            establish_relationships
            establish_validations
            generate_accessor_aliases
            generate_property_readers

            self
          end

        private

          def establish_relationships
            translation_model.belongs_to configuration.translated_model_name,
              :repository   => translated_model.repository.name,
              :unique_index => :unique_locales

            translation_model.belongs_to :locale, DataMapper::I18n::Locale,
              :repository   => DataMapper::I18n.locale_repository_name,
              :unique_index => :unique_locales

            translated_model.has n, configuration.translations, translation_model,
              :repository   => translation_model.repository.name

            translated_model.has n, :locales, DataMapper::I18n::Locale,
              :repository   => DataMapper::I18n.locale_repository_name,
              :through      => configuration.translations,
              :constraint   => :destroy

            self
          end

          def establish_validations
            translation_model.validates_uniqueness_of :locale_id, :scope => configuration.translated_model_fk
          end

          def generate_accessor_aliases
            config = configuration # make config available in the current binding

            translated_model.class_eval do
              alias_method :translations, config.translations

              if config.nested_accessors?
                remixee_attributes = :"#{config.translations}_atttributes"

                accepts_nested_attributes_for config.translations
                alias_method :translations_attributes, remixee_attributes
              end
            end
            self
          end

          def generate_property_readers
            translation_proxy.translatable_properties.each do |property|
              translated_model.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
                def #{property.name}(locale_tag = DataMapper::I18n.default_locale_tag)
                  i18n.translate(:#{property.name}, DataMapper::I18n.normalized_locale_tag(locale_tag))
                end
              RUBY
            end
            self
          end

          def n
            Infinity
          end

        end # class Integrator
      end # class TranslationProxy
    end # module Model
  end # module I18n
end # module DataMapper
