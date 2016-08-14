require_relative './integrations'
require 'faraday'

class APIConnection
  attr_reader :type, :params, :endpoint, :connection
  include API::Integrations

  def initialize(type, params)
    @type = type
    @params = params
    if _valid_config?(type, params)
      @configuration = API::Integrations::SUPPORTED_INTEGRATIONS[type]
    else
      raise "Invalid Config for APIConnection #{type}"
    end
    @endpoint = _build_endpoint(@configuration, @params)
    @connection = _build_connection(@endpoint)
  end

  def _valid_config?(type, params)
    config = API::Integrations::SUPPORTED_INTEGRATIONS[type]
    if config.nil?
      return false
    end
    config[:requirements].each do |requirement|
      if !params.keys.include? requirement
        return false
      end
    end
    param_optional_keys = params.keys - config[:requirements]
    param_optional_keys.each do |opt_key|
      if !config[:optional].include? opt_key
        return false
      end
    end
    return true
  end

  def _build_connection(endpoint)
      Faraday.new(:url => endpoint) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
  end

  def _build_endpoint(configuration, params)
    format = configuration[:format]
    endpoint = format.map do |token|
      if token == :endpoint
        configuration[:endpoint]
      elsif params.keys.include? token
        params[token]
      else
        token
      end
    end
    return endpoint.join("")
  end


  def connected?
    !@connection.nil?
  end
end
