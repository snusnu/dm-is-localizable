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
          resource.translations.all(:fields => [:locale_tag], :unique => true).map { |t| t.locale }
        end

        # translates the given attribute to the locale identified by the given locale_code
        def translate(attribute, locale_tag)
          if locale = DataMapper::I18n::Locale.for(locale_tag)
            t = resource.translations.first(:locale => locale)
            t ? t.send(attribute) : nil
          else
            nil
          end
        end
      end # class Proxy

      module API
        # the proxy instance to delegate api calls to
        def i18n
          @i18n ||= I18n::Resource::Proxy.new(self)
        end
      end # module API
    end # module Resource
  end # module I18n
end # module DataMapper
