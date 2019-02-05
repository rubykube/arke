# Common files
require 'api/api_client'
require 'api/api_error'
require 'api/version'
require 'api/configuration'

# Models
require 'api/models/_barong_api_key'
require 'api/models/_barong_document'
require 'api/models/_barong_label'
require 'api/models/_barong_phone'
require 'api/models/_barong_profile'
require 'api/models/_barong_user'
require 'api/models/_barong_user_with_full_info'
require 'api/models/_barong_user_with_profile'
require 'api/models/_peatio_account'
require 'api/models/_peatio_currency'
require 'api/models/_peatio_deposit'
require 'api/models/_peatio_market'
require 'api/models/_peatio_member'
require 'api/models/_peatio_order'
require 'api/models/_peatio_order_book'
require 'api/models/_peatio_trade'
require 'api/models/_peatio_withdraw'

# APIs
require 'api/api/account_api'
require 'api/api/admin_api'
require 'api/api/identity_api'
require 'api/api/market_api'
require 'api/api/public_api'
require 'api/api/resource_api'

module API
  class << self
    # Customize default settings for the SDK using block.
    #   API.configure do |config|
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
