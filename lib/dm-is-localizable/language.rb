class Language

  include DataMapper::Resource

  DEFAULT_CODE = 'en-US'

  # properties

  property :id,   Serial

  property :code, String, :required => true, :unique => true, :format => /\A[a-z]{2}-[A-Z]{2}\z/
  property :name, String, :required => true

  def self.default
    @default ||= cache[DEFAULT_CODE]
  end

  def self.default_code
    @default_code ||= DEFAULT_CODE
  end

  def self.normalized_code(code)
    code = code.to_s.tr("_","-")
    unless code =~ /\A[a-z]{2}-[A-Z]{2}\z/
      code = "#{code.downcase}-#{code.upcase}"
    end
    code
  end

  def self.[](code)
    cache[normalized_code(code)]
  end

  class << self
    private

    def cache
      @cache ||= Hash.new do |cache, code|
        # TODO find out why dm-core complains
        # when we try to freeze these values
        cache[code] = first(:code => code)
      end
    end
  end

end
