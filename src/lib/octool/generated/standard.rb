require 'kwalify/util/hashlike'

module OCTool


  class Standard
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @name             = hash['name']
      @standard_key     = hash['standard_key']
      @families         = (v=hash['families']) ? v.map!{|e| e.is_a?(ControlFamily) ? e : ControlFamily.new(e)} : v
      @controls         = (v=hash['controls']) ? v.map!{|e| e.is_a?(Control) ? e : Control.new(e)} : v
    end
    attr_accessor :name             # str
    attr_accessor :standard_key     # str
    attr_accessor :families         # seq
    attr_accessor :controls         # seq
  end


  class ControlFamily
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @family_key       = hash['family_key']
      @name             = hash['name']
    end
    attr_accessor :family_key       # str
    attr_accessor :name             # str
  end


  class Control
    include Kwalify::Util::HashLike
    def initialize(hash=nil)
      if hash.nil?
        return
      end
      @control_key      = hash['control_key']
      @family_key       = hash['family_key']
      @name             = hash['name']
      @description      = hash['description']
    end
    attr_accessor :control_key      # str
    attr_accessor :family_key       # str
    attr_accessor :name             # str
    attr_accessor :description      # str
  end

end
