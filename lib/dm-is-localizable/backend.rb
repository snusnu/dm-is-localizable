module DataMapper
  module I18n
    module Backend

      module API
        def default_locale_tag=(tag)
          raise NotImplementedError, "#{self}#default_locale_tag= must be implemented"
        end

        def default_locale_tag
          raise NotImplementedError, "#{self}#default_locale_tag must be implemented"
        end

        def default_translation=(value)
          raise NotImplementedError, "#{self}#default_translation= must be implemented"
        end

        def default_translation
          raise NotImplementedError, "#{self}#default_translation must be implemented"
        end

        def locale_tag_format=(format_regex)
          raise NotImplementedError, "#{self}#locale_tag_format= must be implemented"
        end

        def locale_tag_format
          raise NotImplementedError, "#{self}#locale_tag_format must be implemented"
        end

        def locale_repository_name=(repository_name)
          raise NotImplementedError, "#{self}#locale_repository_name= must be implemented"
        end

        def locale_repository_name
          raise NotImplementedError, "#{self}#locale_repository_name must be implemented"
        end

        def locale_storage_name=(storage_name)
          raise NotImplementedError, "#{self}#locale_storage_name= must be implemented"
        end

        def locale_storage_name
          raise NotImplementedError, "#{self}#locale_storage_name must be implemented"
        end

        def available_locales
          raise NotImplementedError, "#{self}#available_locales must be implemented"
        end

        def normalized_locale_tag(tag)
          raise NotImplementedError, "#{self}#normalized_locale_tag(tag) must be implemented"
        end

        def translation_model_namespace=(namespace)
          raise NotImplementedError, "#{self}#translation_model_namespace= must be implemented"
        end

        def translation_model_namespace
          raise NotImplementedError, "#{self}#translation_model_namespace must be implemented"
        end

        def accepts_nested_attributes=(true_or_false)
          raise NotImplementedError, "#{self}#accepts_nested_attributes= must be implemented"
        end

        def accepts_nested_attributes?
          raise NotImplementedError, "#{self}#accepts_nested_attributes? must be implemented"
        end
      end # module API

    end # module Backend
  end # module I18n
end # module DataMapper
