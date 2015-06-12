module DataMapper
  module I18n
    module Resource
      module Setter
        module Installer
          def translatable(*args, &block)
            # To avoid assigning zsuper return value to an lvar
            # we have to explicitly call super(*args, &block)
            # for the code to work on ruby-1.8.7
            #
            # Weirdly enough, the following works fine without
            # explicit parameter passing (i.e. using zsuper)
            #
            # translated_model = super
            # translated_model.class_eval { ... }
            #
            # On the other hand, doing:
            #
            # super.class_eval { ... }
            #
            # raises the following error:
            #
            # dm-is-localizable/model.rb:48:
            # in `instance_eval': block not supplied (ArgumentError)
            #
            # I have no idea wether this is specific to 1.8.7
            # or if this actually happens on recent rubies as well.
            super(*args, &block).class_eval do
              i18n.translatable_properties.each do |property|
                define_method "#{property.name}=" do |value|
                  translation.send("#{property.name}=", value)
                end
              end
            end
            self
          end
        end

        def self.included(host)
          host.extend(Installer)
          super
        end

        def save(*)
          source_result = super
          target_result = translation.save
          @translation  = nil # reset the current translation
          source_result && target_result
        end

        private

        def translation
          @translation ||= translations.first_or_new(:locale_tag => current_locale)
        end

        def current_locale
          ::I18n.locale
        end
      end # Setter
    end # Resource
  end # I18n
end # DataMapper
