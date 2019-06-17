# frozen_string_literal: true

require 'validates_timeliness'
require 'validates_timeliness/mongoid/version'

ValidatesTimeliness.setup do |config|
  config.extend_orms << :mongoid
end
