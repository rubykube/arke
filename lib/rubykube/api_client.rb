module Rubykube
  class APIClient
    def self.configure(&block)
      SwaggerClient.configure(&block)
      new
    end

    def account
      @account_api ||= SwaggerClient::AccountApi.new
    end
  end
end
