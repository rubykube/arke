require 'pry-byebug'

module Arke::Strategy
  module Copy
    def perform!
      binding.pry
    end
  end
end

