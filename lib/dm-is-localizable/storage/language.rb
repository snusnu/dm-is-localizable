class Language

  include DataMapper::Resource

  # properties

  property :id,   Serial

  property :code, String, :required => true, :unique => true, :format => /\A[a-z]{2}-[A-Z]{2}\z/
  property :name, String, :required => true

  def self.[](code)
    cache[code]
  end

  class << self
    private

    def cache
      @cache ||= Hash.new do |cache, code|
        # TODO find out why dm-core complains
        # when we try to freeze these values
        cache[code] = first(:code => code.to_s.tr('_', '-'))
      end
    end
  end

end
