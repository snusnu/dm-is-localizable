require 'dm-is-localizable/backend'

module DataMapper
  module I18n
    module Backend

      class Default
        include Backend::API

        DEFAULT_LOCALE_TAG             = 'en-US'
        DEFAULT_LOCALE_REPOSITORY_NAME = :default
        DEFAULT_LOCALE_STORAGE_NAME    = 'locales'

        attr_accessor :default_locale_tag
        attr_reader   :locale_tag_format
        attr_reader   :locale_repository_name
        attr_reader   :locale_storage_name

        def initialize
          @default_locale_tag     = DEFAULT_LOCALE_TAG
          @locale_repository_name = DEFAULT_LOCALE_REPOSITORY_NAME
          @locale_storage_name    = DEFAULT_LOCALE_STORAGE_NAME
          @locale_tag_format      = /\A[a-z]{2}-[A-Z]{2}\z/
        end

        def normalized_locale_tag(tag)
          tag = tag.to_s.tr("_","-")
          unless tag =~ locale_tag_format
            tag = "#{tag.downcase}-#{tag.upcase}"
          end
          tag
        end

        def available_locales
          @available_locales ||= Locale.all(:fields => [:locale])
        end
      end # class Default

    end # module Backend
  end # module I18n
end # module DataMapper
