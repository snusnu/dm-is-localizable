module DataMapper
  module I18n
    module Model

      def translatable(options = {}, &block)
        localizer = Localizer.new(self, options, &block)
        localizer.localize
        @i18n = localizer.proxy
        self
      end

      def is_localizable(options = {}, &block)
        warn "#{self}.is_localizable is deprecated, use #{self}.translatable instead (#{caller[2]})"
        translatable(options, &block)
      end

      class Proxy
        attr_reader :model_to_translate
        attr_reader :translation_model

        def initialize(model_to_translate, translation_model)
          @model_to_translate = model_to_translate
          @translation_model  = translation_model
        end

        # list all available locales for the localizable model
        def available_locales
          ids = translation_model.all.map { |t| t.locale_id }.uniq
          ids.any? ? Locale.all(:id => ids) : []
        end

        # returns a list of symbols reflecting all localizable property names of this resource
        def localizable_properties
          translation_model.properties.map { |p| p.name } - non_localizable_properties
        end

        # returns a list of symbols reflecting the names of all the
        # not localizable properties in the remixed translation_model
        def non_localizable_properties
          [ :id, :locale_id, DataMapper::Inflector.foreign_key(model_to_translate.name).to_sym ]
        end
      end # class Proxy

      module API
        # the proxy instance to delegate api calls to
        attr_reader :i18n
      end # module API

      class Localizer

        class Naming

          attr_reader :localizable_model_fk
          attr_reader :localizable_model
          attr_reader :localizations

          def initialize(model, options)
            fk_string             = DataMapper::Inflector.foreign_key(model.name)
            @localizable_model_fk = fk_string.to_sym
            @localizable_model    = fk_string[0, fk_string.rindex('_id')].to_sym
            demodulized           = DataMapper::Inflector.demodulize(options[:model].to_s)
            @localizations        = DataMapper::Inflector.tableize(demodulized).to_sym
          end
        end

        attr_reader :model
        attr_reader :options
        attr_reader :naming
        attr_reader :translation_model
        attr_reader :proxy

        def initialize(model, options, &block)
          @model             = model
          @options           = default_options.merge(options)
          @naming            = Naming.new(@model, @options)
          @translation_model = new_translation_model(&block)
          @proxy             = I18n::Model::Proxy.new(@model, @translation_model)
        end

        def localize
          setup_proxy_accessor_api
          relate_translation_model
          generate_accessor_aliases
          generate_property_readers
          self
        end

      private

        def new_translation_model(&block)
          nc = naming # make nc available in the current binding

          DataMapper::Model.new(options[:model]) do

            property :id, DataMapper::Property::Serial

            belongs_to nc.localizable_model,
              :unique_index => :unique_locales

            belongs_to :locale, DataMapper::I18n::Locale,
              :parent_repository_name => DataMapper::I18n.locale_repository_name,
              :child_repository_name  => self.repository_name,
              :unique_index           => :unique_locales

            validates_uniqueness_of :locale_id, :scope => nc.localizable_model_fk

            class_eval &block
          end
        end

        def setup_proxy_accessor_api
          model.class_eval do
            extend  I18n::Model::API
            include I18n::Resource::API
          end
        end

        def relate_translation_model
          model.has model.n, naming.localizations, translation_model
          model.has model.n, :locales, DataMapper::I18n::Locale,
            :through    => naming.localizations,
            :constraint => :destroy

          self
        end

        def generate_accessor_aliases
          nested_accessors = options[:accepts_nested_attributes]
          nc = naming # make nc available in the current binding

          model.class_eval do
            alias_method :translations, nc.localizations

            if nested_accessors
              remixee_attributes = :"#{nc.localizations}_atttributes"

              accepts_nested_attributes_for nc.localizations
              alias_method :translations_attributes, remixee_attributes
            end
          end
          self
        end

        def generate_property_readers
          proxy.localizable_properties.each do |property_name|
            model.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
              def #{property_name}(locale_tag = DataMapper::I18n.default_locale_tag)
                i18n.translate(:#{property_name}, DataMapper::I18n.normalized_locale_tag(locale_tag))
              end
            RUBY
          end
          self
        end

        def default_options
          {
            :model => "#{model}Translation",
            :accept_nested_attributes => true
          }
        end

      end # class Localizer
    end # module Model
  end # module I18n
end # module DataMapper
