$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'atl_config'

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters'
Minitest::Reporters.use! 
#[Minitest::Reporters::DefaultReporter.new(:color => true)]
