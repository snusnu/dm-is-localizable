module DataMapper
  module Is
    module Localizable

      module Translation

        include DataMapper::Resource

        is :remixable

        property :id,          Serial
        property :language_id, Integer, :min => 1, :required => false

      end

    end
  end
end
