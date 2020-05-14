require 'kwalify/util/hashlike'

module OCTool


  class Certification
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @certification_key = hash['certification_key']
      @name             = hash['name']
      @requires         = (v=hash['requires']) ? v.map!{|e| e.is_a?(ControlID) ? e : ControlID.new(e)} : v
    end
    attr_accessor :certification_key # str
    attr_accessor :name             # str
    attr_accessor :requires         # seq
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
    attr_accessor :standard_key     # str
    attr_accessor :control_key      # str
  end

end
