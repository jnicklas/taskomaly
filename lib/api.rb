require 'yaml'
require 'rest_client'
require 'rexml/document'

module Taskomaly
  
  SERVICE = 'http://taskodone.com/api'
  SUPPORTED_ACTIONS = [ :papers, :paper, :rename, :edit, :new, :delete ]
  
  def self.From file
    return API.new :config => file
  end
  
  def self.With hash
    return API.new hash
  end
  
  class API
    
    attr_reader :response
    attr_reader :papers
    
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
          @config = parse_config(File.expand_path(hash[:config]))
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
        @req = request_generator
        @response = @req.send :post, (base_payload type, *args)
      rescue SocketError
        raise 'the site appears to be unavailable'
      rescue
        raise 'there was an error processing your request'
      end

      return handle_response type, *args
    end

    private
    
    def handle_response type, *args
      doc = REXML::Document.new @response
      case type
      when :papers
        @papers = doc.elements.to_a('//string').map { |m| m.text }
        return @papers
      when :paper
        @data  = doc.elements.to_a('//string').map { |m| m.text }
        return Taskomaly::Paper.new args.first, @data.last, self         
      end
      
    end
    
    def request_generator
      RestClient::Resource.new SERVICE
    end
    
    def parse_config config_filepath
      YAML::load_file config_filepath
    end
    
    def base_payload method_name, *args
      params = ''
      extra_data = ([] << args).flatten.compact
      if extra_data
        extra_data.each do |data|
          type = (data.class == Fixnum) ? 'integer' : 'string'
          params += "<param><value><#{type}>#{data}</#{type}></value></param>\n"          
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