module DataMapper
  module Is
    
    module Localizable
      
      
      def is_localizable(options = {}, &block)
        
        extend  ClassMethods
        include InstanceMethods
        
        options = {
          :as         => nil,
          :class_name => "#{self}Translation"
        }.merge(options)
        
        remixer = Extlib::Inflection.foreign_key(self.name).gsub('_id', '').to_sym
        remixee = Extlib::Inflection.tableize(options[:class_name]).to_sym
        
        remix n, Translation, :as => options[:as], :class_name => options[:class_name]
        
        @translation_class = Extlib::Inflection.constantize(options[:class_name])    
        class_inheritable_accessor :translation_class
        
        enhance :translation, @translation_class do
          belongs_to remixer
          belongs_to :language
          class_eval &block
        end
        
        self.class_eval(<<-EOS, __FILE__, __LINE__ + 1)
          alias :translations #{remixee}
        EOS
        
      end
      
      module ClassMethods
      
        def available_languages
          Language.all :id => translation_class.all.map { |t| t.language_id }.uniq
        end
        
      end
      
      module InstanceMethods
        
        def translate(language, translation)
         # translations << { :language => language }.merge!(translation)
        end
        
      end
      
    end
    
  end
end