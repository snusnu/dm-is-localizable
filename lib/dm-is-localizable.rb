require 'dm-core'
require 'dm-validations'
require 'dm-is-remixable'
require 'dm-accepts_nested_attributes'

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
          raise NotImplementedError, "#{self}#locale_format must be implemented"
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
      end

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
      end
    end

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
    end

    extend API

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

    module Model

      module Translation
        include DataMapper::Resource
        is :remixable
        property :id, Serial
      end

      def is_localizable(options = {}, &block)

        extend  ClassMethods
        include InstanceMethods

        options = {
          :as                       => nil,
          :model                    => "#{self}Translation",
          :accept_nested_attributes => true
        }.merge(options)

        fk_string   = DataMapper::Inflector.foreign_key(self.name)
        remixer_fk  = fk_string.to_sym
        remixer     = fk_string[0, fk_string.rindex('_id')].to_sym # only remove the last occurrence of '_id'
        demodulized = DataMapper::Inflector.demodulize(options[:model].to_s)
        remixee     = DataMapper::Inflector.tableize(demodulized).to_sym

        remix n, Translation, :as => options[:as], :model => options[:model]

        @translation_model = DataMapper::Inflector.constantize(options[:model])

        enhance :translation, @translation_model do

          property remixer_fk, Integer, :min => 1, :required => true, :unique_index => :unique_locales
          property :locale_id, Integer, :min => 1, :required => true, :unique_index => :unique_locales

          belongs_to remixer
          belongs_to :locale, DataMapper::I18n::Locale,
            :parent_repository_name => DataMapper::I18n.locale_repository_name,
            :child_repository_name  => self.repository_name

          class_eval &block

          validates_uniqueness_of :locale_id, :scope => remixer_fk

        end

        has n, :locales, DataMapper::I18n::Locale, :through => remixee, :constraint => :destroy

        self.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)

          alias :translations :#{remixee}

          if options[:accept_nested_attributes]

            # cannot accept_nested_attributes_for :translations
            # since this is no valid relationship name, only an alias

            accepts_nested_attributes_for :#{remixee}
            alias :translations_attributes :#{remixee}_attributes

          end

        RUBY

        localizable_properties.each do |property_name|
          self.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)

            def #{property_name}(locale = DataMapper::I18n.default_locale)
              translate(:#{property_name}, DataMapper::I18n.normalized_locale_tag(locale))
            end

          RUBY
        end

      end

      module ClassMethods

        def translation_model
          @translation_model
        end

        # list all available locales for the localizable model
        def available_locales
          ids = translation_model.all.map { |t| t.locale_id }.uniq
          ids.any? ? Locale.all(:id => ids) : []
        end

        # the number of all available locales for the localizable model
        def nr_of_available_locales
          available_locales.size
        end

        # checks if all localizable resources are translated in all available locales
        def translations_complete?
          available_locales.size * all.size == translation_model.all.size
        end

        # returns a list of symbols reflecting all localizable property names of this resource
        def localizable_properties
          translation_model.properties.map { |p| p.name } - non_localizable_properties
        end

        # returns a list of symbols reflecting the names of all the
        # not localizable properties in the remixed translation_model
        def non_localizable_properties
          [ :id, :locale_id, DataMapper::Inflector.foreign_key(self.name).to_sym ]
        end

      end # module ClassMethods

      module InstanceMethods

        # list all available locales for this instance
        def available_locales
          ids = translations.map { |t| t.locale_id }.uniq
          ids.any? ? Locale.all(:id => ids) : []
        end

        # the number of all available locales for this instance
        def nr_of_available_locales
          available_locales.size
        end

        # checks if this instance is translated into all available locales for this model
        def translations_complete?
          self.class.nr_of_available_locales == translations.size
        end

        # translates the given attribute to the locale identified by the given locale_code
        def translate(attribute, locale_tag)
          if locale = Locale.for(locale_tag)
            t = translations.first(:locale => locale)
            t.respond_to?(attribute) ? t.send(attribute) : nil
          else
            nil
          end
        end

      end # module InstanceMethods

    end # module Model
  end # module I18n

  Model.append_extensions I18n::Model

end # module DataMapper
