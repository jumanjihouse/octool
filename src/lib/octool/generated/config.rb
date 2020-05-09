require 'kwalify/util/hashlike'

module OCTool


  class Config
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @schema_version   = hash['schema_version']
      @name             = hash['name']
      @overview         = hash['overview']
      @maintainers      = hash['maintainers']
      @metadata         = (v=hash['metadata']) && v.is_a?(Hash) ? Metadata.new(v) : v
      @includes         = (v=hash['includes']) ? v.map!{|e| e.is_a?(Include) ? e : Include.new(e)} : v
    end
    attr_accessor :schema_version   # str
    attr_accessor :name             # str
    attr_accessor :overview         # str
    attr_accessor :maintainers      # seq
    attr_accessor :metadata         # map
    attr_accessor :includes         # seq
  end

  ## Optional metadata.
  class Metadata
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @abstract         = hash['abstract']
      @description      = hash['description']
    end
    attr_accessor :abstract         # str
    attr_accessor :description      # str
  end


  class Include
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @type             = hash['type']
      @path             = hash['path']
    end
    attr_accessor :type             # str
    attr_accessor :path             # str
  end

end
