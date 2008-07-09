require 'yaml'

module Taskomaly
  
  class API
    
    attr_accessor :response
    
    # Creates an instance of the API processor with +hash+ passed a set of configuration
    # options in a hash.
    def initialize hash
      @config = {}
      
      raise ArgumentError, 
        'please specify either :user and :key or :config' unless (hash.has_key? :user and hash.has_key? :key) or (hash.has_key? :config)
      
      @config['user'] = hash[:user] if hash.has_key? :user
      @config['key']  = hash[:key]  if hash.has_key? :key
      
      if hash.has_key? :config
        begin
          @config = YAML::load_file(hash[:config])
        rescue
          raise ArgumentError, "unable to load from file #{hash[:config]}"
        end
      end
      
    end
    
    def user; @config['user']; end
    
    def key;  @config['key'];  end
    
  end
  
end