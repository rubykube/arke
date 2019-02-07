# Common files
require 'swagger_client/api_client'
require 'swagger_client/api_error'
require 'swagger_client/configuration'

# Models
require 'swagger_client/models/account'
require 'swagger_client/models/currency'
require 'swagger_client/models/market'
require 'swagger_client/models/order'
require 'swagger_client/models/order_book'
require 'swagger_client/models/trade'

# APIs
require 'swagger_client/api/market'
require 'swagger_client/api/account'
require 'swagger_client/api/public'

module SwaggerClient
  class << self
    # Customize default settings for the SDK using block.
    #   SwaggerClient.configure do |config|
    #     config.username = "xxx"
    #     config.password = "xxx"
    #   end
    #
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end
end
