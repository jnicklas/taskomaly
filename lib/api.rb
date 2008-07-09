require 'yaml'

module Taskomaly
  
  class API
    
    attr_accessor :response
    
    # Creates an instance of the API processor with +hash+ passed a set of configuration
    # options in a hash. +hash+ should either be a Tasko user ID and API key (in this case
    # +:user+ and +:key+), or a file where those keys are located in YAML format (in this case
    # +:config+).
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
    
    private
    
    def base_payload method_name, data = nil
      params = ''
      extra_data = ([] << data).flatten.compact
      if extra_data
        extra_data.each do |data|
          type = (data.class == Fixnum) ? 'integer' : 'string'
          params += "<param><value><#{type}>#{data}</#{type}></value></param>"          
        end
      end
      <<-XML
      <methodCall><methodName>#{method_name}</methodName>
      <params>
      <param><value><int>#{user}</int></value></param>
      <param><value><string>#{key}</string></value></param>
      #{params}
      </params></methodCall> 
      XML
    end
    
    def get_papers_payload
      base_payload 'papers'
    end
    
    def get_paper_payload paper_name
      base_payload 'paper', paper_name
    end
    
  end
  
end