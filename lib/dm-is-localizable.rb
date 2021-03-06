require 'dm-core'
require 'dm-validations'

module DataMapper
  module I18n

    def self.backend=(backend)
      @backend = backend
    end

    def self.backend
      return @backend if @backend
      require 'dm-is-localizable/backend/default'
      @backend = Backend::Default.new
    end

    def self.default_locale_tag=(tag)
      backend.default_locale_tag = tag
    end

    def self.default_locale_tag
      backend.default_locale_tag
    end

    def self.locale_tag_format=(format_regex)
      backend.locale_tag_format = format_regex
    end

    def self.locale_tag_format
      backend.locale_tag_format
    end

    def self.normalized_locale_tag(tag)
      backend.normalized_locale_tag(tag)
    end

    def self.available_locales
      backend.available_locales
    end

    def self.locale_repository_name=(repository_name)
      backend.locale_repository_name = repository_name
    end

    def self.locale_repository_name
      backend.locale_repository_name
    end

    def self.locale_storage_name=(storage_name)
      backend.locale_storage_name = storage_name
    end

    def self.locale_storage_name
      backend.locale_storage_name
    end

    def self.translation_model_namespace=(namespace)
      backend.translation_model_namespace = namespace
    end

    def self.translation_model_namespace
      backend.translation_model_namespace
    end

    def self.accepts_nested_attributes=(true_or_false)
      backend.accepts_nested_attributes = true_or_false
    end

    def self.accepts_nested_attributes?
      backend.accepts_nested_attributes?
    end

  end # module I18n

  require 'dm-is-localizable/support/ext/object'
  require 'dm-is-localizable/backend'
  require 'dm-is-localizable/locale'
  require 'dm-is-localizable/model'
  require 'dm-is-localizable/resource'

  # Activate the extension
  Model.append_extensions I18n::Model

end # module DataMapper
