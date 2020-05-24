# frozen_string_literal: true

require 'octool/version.rb'

# Built-ins.
require 'csv'
require 'pp'

# 3rd-party libs.
require 'kwalify'
require 'kwalify/util/hashlike'

# OCTool libs.
require 'octool/constants'
require 'octool/parser'
require 'octool/ssp'
require 'octool/system'

# Mixins.
module OCTool
    include Kwalify::Util::HashLike # defines [], []=, and keys?
end
