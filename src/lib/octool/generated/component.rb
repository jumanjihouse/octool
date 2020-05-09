require 'kwalify/util/hashlike'

module OCTool


  class Component
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @name             = hash['name']
      @component_key    = hash['component_key']
      @description      = hash['description']
      @attestations     = (v=hash['attestations']) ? v.map!{|e| e.is_a?(Attestation) ? e : Attestation.new(e)} : v
    end
    attr_accessor :name             # str
    attr_accessor :component_key    # str
    attr_accessor :description      # str
    attr_accessor :attestations     # seq
  end


  class Attestation
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @summary          = hash['summary']
      @status           = hash['status']
      @date_verified    = hash['date_verified']
      @satisfies        = (v=hash['satisfies']) ? v.map!{|e| e.is_a?(ControlID) ? e : ControlID.new(e)} : v
      @narrative        = hash['narrative']
    end
    attr_accessor :summary          # str
    attr_accessor :status           # str
    attr_accessor :date_verified    # date
    attr_accessor :satisfies        # seq
    attr_accessor :narrative        # str
  end


  class ControlID
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @standard_key     = hash['standard_key']
      @control_key      = hash['control_key']
    end
    attr_accessor :standard_key     # text
    attr_accessor :control_key      # text
  end

end
