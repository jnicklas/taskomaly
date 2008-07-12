require File.dirname(__FILE__) + '/base'

describe "Taskomaly::API" do

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
  
  it "should work with shortcut methods" do
    t = Taskomaly::From API_CONFIG_LOCATION
    t.user.should == API_CONFIG_USER
    t.key.should == API_CONFIG_KEY
    
    t = Taskomaly::With :user => 9889, :key => 'hurdy-gurdy'
    t.user.should == 9889
    t.key.should == 'hurdy-gurdy'
  end
  
  it "returns papers with itself as an API" do
    t = Taskomaly::From API_CONFIG_LOCATION
    request = mock('RestClient::Resource')
    request.expects(:send).with( :post, t.send( :base_payload, 'paper', 'Test Paper One' ) ).raises(SocketError)

    p = t.request :paper, 'Test Paper One'
    p.send(:api).should == t
  end
  
  it "needs a place to store a response from the server" do
    t = Taskomaly::API.new :config => API_CONFIG_LOCATION
    t.respond_to?( :response, true ).should == true
  end
  
  it "should format a base payload correctly" do
    xml = <<-XML
    <methodCall><methodName>test_method</methodName>
    <params>
    <param><value><int>#{API_CONFIG_USER}</int></value></param>
    <param><value><string>#{API_CONFIG_KEY}</string></value></param>
    </params></methodCall>
    XML
    t = Taskomaly::API.new :config => API_CONFIG_LOCATION
    t.send( :base_payload, 'test_method' ).gsub(/[ \n]/, '').should == xml.strip.gsub(/[ \n]/, '')
  end
  
  it "should format any parameters into a payload correctly" do
    xml = <<-XML
    <methodCall><methodName>test_method</methodName>
    <params>
    <param><value><int>#{API_CONFIG_USER}</int></value></param>
    <param><value><string>#{API_CONFIG_KEY}</string></value></param>
    <param><value><string>this is a test</string></value></param>
    <param><value><integer>37</integer></value></param>
    <param><value><string>signals</string></value></param>
    </params></methodCall>
    XML
    t = Taskomaly::API.new :config => API_CONFIG_LOCATION
    t.send( :base_payload, 'test_method', [ 'this is a test', 37, 'signals' ] ).gsub(/[ \n]/, '').should == xml.strip.gsub(/[ \n]/, '')
  end
  
  it "only supports the actions specified by the API" do
    pending "Not done yet"
  end
  
  it "must raise an error if the server is unavailable" do
    t = Taskomaly::API.new :config => API_CONFIG_LOCATION

    request = mock('RestClient::Resource')
    request.expects(:send).with( :post, t.send( :base_payload, 'papers' ) ).raises(SocketError)
    
    t.stubs(:request_generator).returns(request)
    lambda { t.request :papers }.should raise_error(RuntimeError, 'the site appears to be unavailable')
  end

  it "can retrieve a response from the server" do
    xml = <<-XML
    <?xml version='1.0' encoding='UTF-8'?>
    <methodResponse>
    	<params><param><value><array><data>
    		<value><string>Paper One</string></value>
    		<value><string>Paper Two</string></value>
    	</data></array></value></param></params>
    </methodResponse>
    XML
    
    t = Taskomaly::API.new :config => API_CONFIG_LOCATION
    
    request = mock('RestClient::Resource')
    request.expects(:send).with( :post, t.send( :base_payload, 'papers') ).returns(xml)
    
    t.stubs(:request_generator).returns(request)
    t.request :papers
    t.response.should_not == nil
  end

  it "can retrieve a list of papers from the server" do
    xml = <<-XML
    <?xml version='1.0' encoding='UTF-8'?>
    <methodResponse>
    	<params><param><value><array><data>
    		<value><string>Paper One</string></value>
    		<value><string>Paper Two</string></value>
    	</data></array></value></param></params>
    </methodResponse>
    XML
    
    t = Taskomaly::API.new :config => API_CONFIG_LOCATION
    
    request = mock('RestClient::Resource')
    request.expects(:send).with( :post, t.send( :base_payload, 'papers') ).returns(xml)
    
    t.stubs(:request_generator).returns(request)
    papers = t.request :papers
    papers.sort.should == ['Paper One', 'Paper Two']
    papers.size.should == 2
  end

  it "can synchronize a local file with the server copy" do
    pending "Not done yet"
  end

  it "can load a configuration file specified relative to ~" do
    file_loc = '~/.test_tasks.yml'
    Taskomaly::API.any_instance.stubs(:parse_config).with(File.expand_path(file_loc)).returns({'user' => API_CONFIG_USER, 'key' => API_CONFIG_KEY})
    t = Taskomaly::API.new :config => file_loc
    t.user.should == API_CONFIG_USER
    t.key.should == API_CONFIG_KEY  
  end

end