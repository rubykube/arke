require 'pry'
require 'arke/strategy'

module Arke
  module Command
    class Console < Clamp::Command
      option '--usage', :flag, 'Show the API client usage example'

      def execute
        Pry.hooks.add_hook(:before_session, 'arke_load') do |output, binding, pry|
          print_usage if usage?
          output.puts "Arke development console"
        end

        # binding.pry
        Pry.config.prompt_name = 'arke'
        Pry.config.requires = ['openssl']
        Pry.start
      end

      private

      def print_usage
        puts "================= Example API request ================="
        puts
        puts "# Configure the API client"
        puts "api = Rubykube::APIClient.configure do |config|"
        puts "  config.api_key = 'xxxxxxxxxxxxx'"
        puts "  config.api_key_secret = 'xxxxxxxxxxxxxxxxxxxxxxx'"
        puts "  config.debugging = true"
        puts "end"
        puts
        puts "# List all your wallets balances"
        puts "api.account.get_accounts_balances"
        puts
        puts "======================================================"
        puts
      end
    end
  end
end
