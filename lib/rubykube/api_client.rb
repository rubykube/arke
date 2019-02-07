module Rubykube
  class APIClient
    def self.configure(&block)
      API.configure(&block)
      new
    end

    def account
      @account_api ||= API::AccountApi.new
    end
  end
end
