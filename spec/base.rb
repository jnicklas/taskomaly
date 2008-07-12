require 'rubygems'
require 'mocha'
require 'spec'
require 'yaml'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

TEST_PAPERS = YAML::load_file(File.join(File.dirname(__FILE__), 'fixtures', 'test_papers.yml'))
%w/ one two/.each do |task| 
  eval "TEST_PAPER_#{task.upcase}_LOC = 'test_paper_#{task}.tasks'"
  eval "TEST_PAPER_#{task.upcase} = TEST_PAPERS['test_paper_#{task}.tasks']"
end

API_CONFIG_LOCATION = File.join(File.dirname(__FILE__), 'fixtures', 'api_config.yml')
API_CONFIG_USER = 8125
API_CONFIG_KEY  = 'de18208d17dcc2aa007574fdb7c26322'

require 'taskomaly'