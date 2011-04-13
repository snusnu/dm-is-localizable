module DataMapper
  module Ext
    module Object
      def self.namespace(object)
        object = object.to_s
        path   = object.split('::')
        return ::Object if path.size == 1
        DataMapper::Ext::Object.full_const_get(path[0..path.size - 2].join('::'))
      end
    end
  end
end
