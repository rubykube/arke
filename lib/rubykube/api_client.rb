module Rubykube
  module APIClient
    def self.configure(&block)
      SwaggerClient.configure(&block)
    end
  end
end
