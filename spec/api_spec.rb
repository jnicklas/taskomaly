require File.dirname(__FILE__) + '/base'

describe "Taskomaly::API" do

  API_CONFIG_LOCATION = File.join(File.dirname(__FILE__), 'fixtures', 'api_config.yml')
  API_CONFIG_USER = 8125
  API_CONFIG_KEY  = 'de18208d17dcc2aa007574fdb7c26322'
  
  LOCAL_TEST_PROJECT  = File.join(File.dirname(__FILE__), 'fixtures', 'test_project_one.taskPaper')

  before do
    
    opts = { 'user' => API_CONFIG_USER, 'key' => API_CONFIG_KEY }
    File.open( API_CONFIG_LOCATION, 'w' ) do |out|
        YAML.dump( opts, out )
      end
  end

  it "requires both a user ID and an API key, or the location of a configuration file" do
    lambda { bad_t = Taskomaly::API.new }.should raise_error( ArgumentError )
    lambda { bad_t = Taskomaly::API.new :user => 0 }.should raise_error( ArgumentError )
    lambda { bad_t = Taskomaly::API.new :key => 'mumbo-jumbo' }.should raise_error( ArgumentError )
    
    t = Taskomaly::API.new :user => 9999, :key => 'mumbo-jumbo'
    t.user.should == 9999
    t.key.should == 'mumbo-jumbo'
    
    lambda { config_t = Taskomaly::API.new :config => API_CONFIG_LOCATION }.should_not raise_error( ArgumentError )
  end

  it "can load a user ID and API key from a configuration file" do
    t = Taskomaly::API.new :config => API_CONFIG_LOCATION
    t.user.should == API_CONFIG_USER
    t.key.should  == API_CONFIG_KEY
  end
  
  it "should raise an error if a specified configured file does not exist" do
    lambda { bad_t = Taskomaly::API.new :config => 'i_do_not_exist.yml' }.should raise_error( ArgumentError )
  end

  it "needs a place to store a response from the server" do
    t = Taskomaly::API.new :config => API_CONFIG_LOCATION
    t.respond_to?( :response, true ).should == true
  end

  it "can retrieve a response from the server" do
    pending "Not done yet"
  end

  it "can retrieve a list of papers from the server" do
    pending "Not done yet"
  end

  it "can say how many papers have been retrieved" do
    pending "Not done yet"
  end

  it "can synchronize a local file with the server copy" do
    pending "Not done yet"
  end

end