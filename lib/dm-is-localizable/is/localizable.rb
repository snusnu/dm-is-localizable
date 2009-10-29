module DataMapper
  module Is

    module Localizable


      def is_localizable(options = {}, &block)

        extend  ClassMethods
        include InstanceMethods

        options = {
          :as                       => nil,
          :model                    => "#{self}Translation",
          :accept_nested_attributes => true
        }.merge(options)

        remixer_fk = Extlib::Inflection.foreign_key(self.name).to_sym
        remixer    = remixer_fk.to_s.gsub('_id', '').to_sym
        remixee    = Extlib::Inflection.tableize(options[:model]).to_sym

        remix n, Translation, :as => options[:as], :model => options[:model]

        @translation_model = Extlib::Inflection.constantize(options[:model])

        enhance :translation, @translation_model do

          property remixer_fk,   Integer, :min => 0, :nullable => false, :unique_index => :unique_languages
          property :language_id, Integer, :min => 0, :nullable => false, :unique_index => :unique_languages

          belongs_to remixer
          belongs_to :language

          class_eval &block

          validates_is_unique :language_id, :scope => remixer_fk

        end

        has n, :languages, :through => remixee, :constraint => :destroy

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

            def #{property_name}(language_code)
              translate(:#{property_name.to_sym}, language_code)
            end

          RUBY
        end

      end

      module ClassMethods

        def translation_model
          @translation_model
        end

        # list all available languages for the localizable model
        def available_languages
          ids = translation_model.all.map { |t| t.language_id }.uniq
          ids.empty? ? [] : Language.all(:id => ids)
        end

        # the number of all available languages for the localizable model
        def nr_of_available_languages
          available_languages.size
        end

        # checks if all localizable resources are translated in all available languages
        def translations_complete?
          available_languages.size * all.size == translation_model.all.size
        end

        # returns a list of symbols reflecting all localizable property names of this resource
        def localizable_properties
          translation_model.properties.map { |p| p.name }.select do |p|
            # exclude properties that are'nt localizable
            p != :id && p != :language_id && p != Extlib::Inflection.foreign_key(self.name).to_sym
          end
        end

      end

      module InstanceMethods

        # list all available languages for this instance
        def available_languages
          ids = translations.map { |t| t.language_id }.uniq
          ids.empty? ? [] : Language.all(:id => ids)
        end

        # the number of all available languages for this instance
        def nr_of_available_languages
          available_languages.size
        end

        # checks if this instance is translated into all available languages for this model
        def translations_complete?
          self.class.nr_of_available_languages == translations.size
        end

        # translates the given attribute to the language identified by the given language_code
        def translate(attribute, language_code)
          if language = Language[language_code]
            t = translations.first(:language_id => language.id)
            t.respond_to?(attribute) ? t.send(attribute) : nil
          else
            nil
          end
        end

      end

    end

  end
end
