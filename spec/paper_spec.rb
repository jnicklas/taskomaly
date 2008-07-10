require File.dirname(__FILE__) + '/base'

describe "Taskomaly::Paper" do

  TEST_PAPER_ONE_LOC = File.join(File.dirname(__FILE__), 'fixtures', 'test_paper_one.tasks')
  TEST_PAPER_ONE = File.open(TEST_PAPER_ONE_LOC, "r").readlines

  before do
    t = Taskomaly::API.new :user => 9999, :key => 'd9cca721a735dac4efe709e0f3518373'
    t.stubs(:papers).returns( ['Test Paper One', 'Test Paper Two'] )
  end
  
  it "requires a name" do
    lambda { p = Taskomaly::Paper.new }.should raise_error(ArgumentError)
    p = Taskomaly::Paper.new 'Test Paper'
    p.name.should == 'Test Paper'
  end
  
  it "should be an empty document when first created" do
    p = Taskomaly::Paper.new 'Test Paper'
    p.name.should == 'Test Paper'
    p.body.should == ''
  end
  
  it "should be allowed to be created with a body" do
    p = Taskomaly::Paper.new 'Test Paper', TEST_PAPER_ONE
    p.name.should == 'Test Paper'
    p.body.should == TEST_PAPER_ONE
  end

  it "can be loaded in directly from an existing file and parsed" do
    p = Taskomaly::Paper::from TEST_PAPER_ONE_LOC
    p.name.should == 'Test Paper One'
    p.body.should == TEST_PAPER_ONE
  end

  it "can be renamed" do
    pending "Not done yet"
  end

  it "can be edited" do
    pending "Not done yet"
  end

  it "requires a place to store an API" do
    p = Taskomaly::Paper.new 'Test Paper'
    p.respond_to?( :api, true ).should == true
  end

  it "has an API set when retrieved from an API object" do
    p = t.get :paper, 'Test Paper One'
    p.api.should == t
  end

  it "can be refreshed from the server" do
    pending "Not done yet"
  end
  
  it "can be saved to the server" do
    pending "Not done yet"
  end
  
  it "will not save to the server if not provided an API" do
    p = Taskomaly::Paper.new 'Test Paper One', TEST_PAPER_ONE
    p.name = 'Test Paper One Ultra'
    p.body = "The New Plan:\n- just be awesome @done"
    p.save.should == false
  end
  
  it "can be deleted from the server" do
    pending "Not done yet"
  end

  it "can retrieve a list of all projects" do
    pending "Not done yet"
  end

  it "can retrieve a list of all tasks in a project" do
    pending "Not done yet"
  end

  it "can retrieve all tags in a given project" do
    pending "Not done yet"
  end
  
  it "can retrieve all comments in a given project" do
    pending "Not done yet"
  end
  
  it "can say which line in the project each comment is on" do
    pending "Not done yet"
  end

end