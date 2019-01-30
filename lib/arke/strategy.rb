# get our rubykube API
require 'swagger_client'

require 'arke/strategy/copy'

module Arke
  module Strategy
    module RubykubeAPI
      include SwaggerClient
    end
  end
end
