require 'dm-is-localizable/backend'

module DataMapper
  module I18n
    module Backend

      class Default
        include Backend::API

        DEFAULT_LOCALE_TAG                         = 'en-US'
        DEFAULT_TRANSLATION                        = nil
        DEFAULT_LOCALE_REPOSITORY_NAME             = :default
        DEFAULT_LOCALE_STORAGE_NAME                = 'locales'
        DEFAULT_TRANSLATION_MODEL_NAMESPACE        = nil
        USE_VALIDATIONS                            = false
        ACCEPTS_NESTED_ATTRIBUTES                  = true
        DEFAULT_PROPERTY_READER_DEFAULT_LOCALE_TAG = "DataMapper::I18n.default_locale_tag"

        # RFC 4646/47
        DEFAULT_LOCALE_TAG_FORMAT = %r{\A(?:
          ([a-z]{2,3}(?:(?:-[a-z]{3}){0,3})?|[a-z]{4}|[a-z]{5,8}) # language
          (?:-([a-z]{4}))?                                        # script
          (?:-([a-z]{2}|\d{3}))?                                  # region
          (?:-([0-9a-z]{5,8}|\d[0-9a-z]{3}))*                     # variant
          (?:-([0-9a-wyz](?:-[0-9a-z]{2,8})+))*                   # extension
          (?:-(x(?:-[0-9a-z]{1,8})+))?|                           # privateuse subtag
          (x(?:-[0-9a-z]{1,8})+)|                                 # privateuse tag
          /* ([a-z]{1,3}(?:-[0-9a-z]{2,8}){1,2}) */               # grandfathered
          )\z}xi

        attr_accessor :default_locale_tag
        attr_accessor :default_translation
        attr_accessor :property_reader_default_locale_tag
        attr_accessor :locale_tag_format
        attr_accessor :locale_repository_name
        attr_accessor :locale_storage_name
        attr_accessor :translation_model_namespace
        attr_writer   :use_validations
        attr_writer   :accepts_nested_attributes

        def initialize
          @default_locale_tag                 = DEFAULT_LOCALE_TAG
          @default_translation                = DEFAULT_TRANSLATION
          @locale_repository_name             = DEFAULT_LOCALE_REPOSITORY_NAME
          @locale_storage_name                = DEFAULT_LOCALE_STORAGE_NAME
          @locale_tag_format                  = DEFAULT_LOCALE_TAG_FORMAT
          @translation_model_namespace        = DEFAULT_TRANSLATION_MODEL_NAMESPACE
          @use_validations                    = USE_VALIDATIONS
          @accepts_nested_attributes          = ACCEPTS_NESTED_ATTRIBUTES
          @property_reader_default_locale_tag = DEFAULT_PROPERTY_READER_DEFAULT_LOCALE_TAG
        end

        def normalized_locale_tag(tag)
          tag # noop, overwrite for specific behavior
        end

        def available_locales
          DataMapper::I18n::Locale.all
        end

        def accepts_nested_attributes?
          @accepts_nested_attributes
        end

        def use_validations?
          @use_validations
        end
      end # class Default

    end # module Backend
  end # module I18n
end # module DataMapper
