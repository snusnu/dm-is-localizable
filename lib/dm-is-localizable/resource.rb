module DataMapper
  module I18n
    module Resource
      class Proxy
        attr_reader :resource

        def initialize(resource)
          @resource = resource
        end
        # list all available locales for this instance
        def available_locales
          ids = resource.translations.map { |t| t.locale_id }.uniq
          ids.any? ? Locale.all(:id => ids) : []
        end

        # the number of all available locales for this instance
        def nr_of_available_locales
          available_locales.size
        end

        # checks if this instance is translated into all available locales for this model
        def translations_complete?
          resource.model.nr_of_available_locales == resource.translations.size
        end

        # translates the given attribute to the locale identified by the given locale_code
        def translate(attribute, locale_tag)
          if locale = Locale.for(locale_tag)
            t = resource.translations.first(:locale => locale)
            t.respond_to?(attribute) ? t.send(attribute) : nil
          else
            nil
          end
        end
      end # class Proxy

      module API
        # the proxy instance to delegate api calls to
        def i18n
          raise NotImplementedError, "#{self}#i18n must be implemented"
        end

        # list all available locales for this instance
        def available_locales
          i18n.available_locales
        end

        # the number of all available locales for this instance
        def nr_of_available_locales
          i18n.nr_of_available_locales
        end

        # checks if this instance is translated into all available locales for this model
        def translations_complete?
          i18n.translations_complete?
        end

        # translates the given attribute to the locale identified by the given locale_code
        def translate(attribute, locale_tag)
          i18n.translate(attribute, locale_tag)
        end
      end # module API
    end # module Resource
  end # module I18n
end # module DataMapper
