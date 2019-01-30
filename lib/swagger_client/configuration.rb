require 'uri'

module SwaggerClient
  class Configuration
    # Defines url scheme
    attr_accessor :scheme

    # Defines url host
    attr_accessor :host

    attr_reader :base_path

    # Defines API keys used with API Key authentications.
    attr_accessor :api_key

    # Defines API key prefixes used with API Key authentications.
    #
    # @return [Hash] key: parameter name, value: API key prefix
    #
    # @example parameter name is "Authorization", API key prefix is "Token" (e.g. "Authorization: Token xxx" in headers)
    #   config.api_key_prefix['api_key'] = 'Token'
    attr_accessor :api_key_prefix

    # Set this to enable/disable debugging. When enabled (set to true), HTTP request/response
    # details will be logged with `logger.debug` (see the `logger` attribute).
    # Default to false.
    #
    # @return [true, false]
    attr_accessor :debugging

    # Defines the logger used for debugging.
    # Default to `Rails.logger` (when in Rails) or logging to STDOUT.
    #
    # @return [#debug]
    attr_accessor :logger

    # Defines the temporary folder to store downloaded files
    # (for API endpoints that have file response).
    # Default to use `Tempfile`.
    #
    # @return [String]
    attr_accessor :temp_folder_path

    # The time limit for HTTP request in seconds.
    # Default to 0 (never times out).
    attr_accessor :timeout

    def initialize
      @scheme = 'https'
      @host = 'www.microkube.com'
      @base_path = '/api/v2'
      @api_key = {}
      @api_key_prefix = {}
      @timeout = 0
      @debugging = false
      @logger = Logger.new(STDOUT)

      yield(self) if block_given?
    end

    # The default Configuration object.
    def self.default
      @@default ||= Configuration.new
    end

    def configure
      yield(self) if block_given?
    end

    def scheme=(scheme)
      # remove :// from scheme
      @scheme = scheme.sub(%r{://}, '')
    end

    def host=(host)
      # remove http(s):// and anything after a slash
      @host = host.sub(%r{https?://}, '').split('/').first
    end

    def base_path=(base_path)
      # Add leading and trailing slashes to base_path
      @base_path = "/#{base_path}".gsub(%r{/+}, '/')
      @base_path = '' if @base_path == '/'
    end

    def base_url
      url = "#{scheme}://#{[host, base_path].join('/').gsub(%r{/+}, '/')}".sub(%r{/+\z}, '')
      URI.encode(url)
    end
  end
end
