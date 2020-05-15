# frozen_string_literal: true

require 'octool/version.rb'

# Built-ins.
require 'pp'
require 'tmpdir'

# 3rd-party libs.
require 'kwalify'
require 'kwalify/util/hashlike'

# OCTool libs.
require 'octool/constants'
require 'octool/parser'
require 'octool/ssp'
require 'octool/system'

# Generated libs.
require 'octool/generated/certification'
require 'octool/generated/component'
require 'octool/generated/config'
require 'octool/generated/standard'

# Mixins.
module OCTool
    include Kwalify::Util::HashLike # defines [], []=, and keys?
end
