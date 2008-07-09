require 'yaml'
require 'rest_client'

module Taskomaly
  
  SERVICE = 'http://taskodone.com/api'
  SUPPORTED_ACTIONS = [ :papers, :paper, :rename, :edit, :new, :delete ]
  
  class API
    
    attr_reader :response
    
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
        
    def request type, *args
      raise ArgumentError, "invalid send request type #{type}" unless SUPPORTED_ACTIONS.include? type

      begin
        req = RestClient::Resource.new SERVICE
        @response = req.send :post, (base_payload type, *args)
      rescue
        raise RuntimeError, 'there was an error sending your request'
      end
    end

    private
  
    def base_payload method_name, *args
      params = ''
      extra_data = ([] << args).flatten.compact
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
    
  end
  
end