# Arke

Arke is a trading bot platform built by RubyKube.

## Development

### Setup

To start local development:

1. Clone the repo:
   ```shell
   git clone git@github.com:rubykube/arke.git`
   ```
2. Install dependencies
   ```shell
   bundle install
   ```

Now you can run Arke using `bin/arke` command.

### Example usage

To open development console, use `bin/arke console`

```ruby
# Configure the API client
api = Rubykube::APIClient.configure do |config|
  config.api_key = 'xxxxxxxxxxxxx'
  config.api_key_secret = 'xxxxxxxxxxxxxxxxxxxxxxx'
  config.debugging = true
end

# List all your wallets balances
api.account.get_accounts_balances
```

You can also print this example when starting the console:

```shell
$ bin/arke console --usage
================= Example API request =================

# Configure the API client
api = Rubykube::APIClient.configure do |config|
# ...
```
