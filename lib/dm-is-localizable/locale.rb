module DataMapper
  module I18n
    class Locale
      include DataMapper::Resource

      storage_names[DataMapper::I18n.locale_repository_name] =
        DataMapper::I18n.locale_storage_name

      property :id,   Serial
      property :tag,  String, :required => true, :unique => true, :format => DataMapper::I18n.locale_tag_format
      property :name, String, :required => true

      def self.for(tag)
        cache[tag]
      end

      class << self
        private

        def cache
          @cache ||= Hash.new do |cache, tag|
            # TODO find out why dm-core complains
            # when we try to freeze these values
            cache[tag] = first(:tag => DataMapper::I18n.normalized_locale_tag(tag))
          end
        end
      end
    end # class Locale
  end # module I18n
end # module DataMapper
