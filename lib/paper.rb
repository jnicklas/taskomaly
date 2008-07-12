module Taskomaly
  
  class Paper
    
    attr_accessor :name, :body
    
    def self.From file
      raise ArgumentError, "file #{file} does not exist" unless File.exist? file
      return Paper.new(
        file.gsub(/\.\w+$/, '').gsub(/^.*\//, '').gsub(/[-_]/, ' ').split(' ').each{|word| word.capitalize! }.join(' '),
        File.open(file, "r").readlines.join
        )
    end
    
    def initialize name, body = "", api = nil
      @name = name
      @body = body
      @api  = api
    end
    
    def api
      return @api
    end
    
    def save
      return false unless @api
    end
    
    def refresh
      return false unless @api
    end
    
    private
    
    def parse_body
      @projects = []
      @body.split('\n').each do |line|
        
      end
    end
    
  end
  
end