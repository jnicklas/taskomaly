require File.dirname(__FILE__) + '/base'

describe "Taskomaly::Paper" do

  before do
    @t = Taskomaly::API.new :user => 9999, :key => 'd9cca721a735dac4efe709e0f3518373'
    @t.stubs(:papers).returns( ['Test Paper One', 'Test Paper Two'] )
    @t.stubs(:request).with(:paper, 'Test Paper Two').returns(Taskomaly::Paper.new 'Test Paper Two', TEST_PAPERS['test_paper_two.tasks'], @t)
    
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
    p = Taskomaly::Paper::From File.join(File.dirname(__FILE__), 'fixtures', 'existing_test_paper.tasks')
    p.name.should == 'Existing Test Paper'
    p.body.should == TEST_PAPERS['existing_test_paper.tasks']
  end

  it "can be renamed" do
    p = Taskomaly::Paper.new 'Test Paper One'
    p.name.should == 'Test Paper One'
    p.name = 'Ultra Awesome Test Paper'
    p.name.should == 'Ultra Awesome Test Paper'
  end

  it "can be edited" do
    p = Taskomaly::Paper.new 'Test Paper One', TEST_PAPERS['test_paper_one.tasks']
    p.body.should == TEST_PAPER_ONE
    p.body = "The New Plan:\n- just be awesome @done"
    p.body.should == "The New Plan:\n- just be awesome @done"
  end

  it "requires a place to store an API" do
    p = Taskomaly::Paper.new 'Test Paper'
    p.respond_to?( :api, true ).should == true
  end
  
  it "cannot be refreshed from the server if not provided an API" do
    p = Taskomaly::Paper.new 'Test Paper'
    p.body = "The New Plan:\n- just be awesome @done"
    p.refresh.should == false
  end
  
  it "can be refreshed from the server" do
    
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