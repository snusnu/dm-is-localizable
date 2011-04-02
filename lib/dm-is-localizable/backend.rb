module DataMapper
  module I18n

    def self.backend=(backend)
      @backend = backend
    end

    def self.backend
      @backend ||= Backend::Default.new
    end

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
      end # API

      class Default
        include API

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

    module API
      include Backend::API

      def default_locale_tag=(tag)
        backend.default_locale_tag = tag
      end

      def default_locale_tag
        backend.default_locale_tag
      end

      def locale_tag_format
        backend.locale_tag_format
      end

      def normalized_locale_tag(tag)
        backend.normalized_locale_tag(tag)
      end

      def available_locales
        backend.available_locales
      end

      def locale_repository_name
        backend.locale_repository_name
      end

      def locale_storage_name
        backend.locale_storage_name
      end
    end # module API

    extend API

  end # module I18n
end # module DataMapper

