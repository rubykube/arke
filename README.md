[![Build Status](https://ci.microkube.com/api/badges/rubykube/arke/status.svg)](https://ci.microkube.com/rubykube/arke)

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

Add platform host and credentials to `config/variables.yaml`

```yaml
host: "http://www.devkube.com"
api_key:
  key: 'xxxxxxxxxxxxx'
  secret: 'xxxxxxxxxxxxxxxxxxxxxxx'
```

To open development console, use `bin/arke console`

Now your configuration variables can be reached with
```ruby
Arke.configuration.variable_name

# For example, to get host:

Arke.configuration.host

#For api key:
Arke.configuration.api_key['key'] # for key
Arke.configuration.api_key['secret'] # for secret
```
And then, to use market api

```ruby
market_api = Rubykube::MarketApi.new(
  Arke.configuration.host,
  Arke.configuration.api_key['key'],
  Arke.configuration.api_key['secret']
)

market_api.create_order(order_attrs) # order_attrs - ruby hash with request parameters
```

To start trading bot type

```shell
bin/arke start
```
