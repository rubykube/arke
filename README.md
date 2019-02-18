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

Arke is a liquidity aggregation tool which supports copy strategy

![ArkeStructure](/home/den/work/rubykube/arke/.assets/ArkeStructure.jpg)Add platform host and credentials to `config/strategy.yaml`

```yaml
strategy:
  type: 'copy'
  pair: 'ETHUSD'
  target:
    driver: rubykube
    host: "http://www.example1.com"
    name: John
    key: "xxxxxxxxxx"
    secret: "xxxxxxxxxx"
  sources:
    - driver: source1
      host: "http://www.example2.com"
      name: Joe
      key: "xxxxxxxxxxx"
      secret: "xxxxxxxxxxxx"
    - driver: source2
      host: "http://www.example2.com"
      name: Joe
      key: "xxxxxxxxxxx"
      secret: "xxxxxxxxxxxx"
```

To open development console, use `bin/arke console`

Now your configuration variables can be reached with
```ruby
Arke::Configuration.get(:variable_name)
# or
Arke::Configuration.require!(:variable_name)

# For example, to get target host:
Arke::Configuration.require!(:target)['host']

#For api key:
Arke::Configuration.require!(:target)['key']
Arke::Configuration.require!(:target)['secret']
```
To use market API:

```ruby
market_api = Rubykube::MarketApi.new(
    Arke::Configuration.require!(:target)['host'],
    Arke::Configuration.require!(:target)['key'],
	Arke::Configuration.require!(:target)['secret']
)

market_api.create_order(order_attrs) # order_attrs - ruby hash with request parameters
```

To start trading bot type

```shell
bin/arke start
```
