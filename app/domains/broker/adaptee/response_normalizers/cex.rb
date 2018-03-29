# frozen_string_literal: true

module Broker
  module Adaptee
    module ResponseNormalizers
      # Responsible for normalizing response from API
      module Cex
        def order_book(response)
          response
        end
        module_function :order_book
      end
    end
  end
end
