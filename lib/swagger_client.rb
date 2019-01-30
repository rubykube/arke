# Common files
require 'swagger_client/api_client'
require 'swagger_client/api_error'
require 'swagger_client/version'
require 'swagger_client/configuration'

# Models
require 'swagger_client/models/_barong_api_key'
require 'swagger_client/models/_barong_document'
require 'swagger_client/models/_barong_label'
require 'swagger_client/models/_barong_phone'
require 'swagger_client/models/_barong_profile'
require 'swagger_client/models/_barong_user'
require 'swagger_client/models/_barong_user_with_full_info'
require 'swagger_client/models/_barong_user_with_profile'
require 'swagger_client/models/_peatio_account'
require 'swagger_client/models/_peatio_currency'
require 'swagger_client/models/_peatio_deposit'
require 'swagger_client/models/_peatio_market'
require 'swagger_client/models/_peatio_member'
require 'swagger_client/models/_peatio_order'
require 'swagger_client/models/_peatio_order_book'
require 'swagger_client/models/_peatio_trade'
require 'swagger_client/models/_peatio_withdraw'

# APIs
require 'swagger_client/api/account_api'
require 'swagger_client/api/admin_api'
require 'swagger_client/api/identity_api'
require 'swagger_client/api/market_api'
require 'swagger_client/api/public_api'
require 'swagger_client/api/resource_api'

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
