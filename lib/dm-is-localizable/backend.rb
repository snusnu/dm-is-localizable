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

        def locale_tag_format
          raise NotImplementedError, "#{self}#locale_tag_format must be implemented"
        end

        def locale_repository_name
          raise NotImplementedError, "#{self}#locale_repository_name must be implemented"
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
      end # module API

    end # module Backend
  end # module I18n
end # module DataMapper
