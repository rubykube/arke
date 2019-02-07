require "uri"

module SwaggerClient
  module API
    class Public
      attr_accessor :api_client

      def initialize(api_client = ApiClient.default)
        @api_client = api_client
      end

      # Get list of currencies
      # @param [Hash] opts the optional parameters
      # @option opts [String] :type Currency type
      # @return [Array<Currency>]
      def get_public_currencies(opts = {})
        data, _status_code, _headers = get_public_currencies_with_http_info(opts)
        data
      end

      # Get a currency
      # @param id Currency code.
      # @param [Hash] opts the optional parameters
      # @return [Currency]
      def get_public_currencies_id(id, opts = {})
        data, _status_code, _headers = get_public_currencies_id_with_http_info(id, opts)
        data
      end

      # Returns deposit fees for currencies.
      # @param [Hash] opts the optional parameters
      # @return [nil]
      def get_public_fees_deposit(opts = {})
        get_public_fees_deposit_with_http_info(opts)
        nil
      end

      # Returns trading fees for markets.
      # @param [Hash] opts the optional parameters
      # @return [nil]
      def get_public_fees_trading(opts = {})
        get_public_fees_trading_with_http_info(opts)
        nil
      end

      # Returns withdraw fees for currencies.
      # @param [Hash] opts the optional parameters
      # @return [nil]
      def get_public_fees_withdraw(opts = {})
        get_public_fees_withdraw_with_http_info(opts)
        nil
      end

      # Get depth or specified market. Both asks and bids are sorted from highest price to lowest.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :limit Limit the number of returned price levels. Default to 300. (default to 300)
      # @return [nil]
      def get_public_markets_market_depth(market, opts = {})
        get_public_markets_market_depth_with_http_info(market, opts)
        nil
      end

      # Get OHLC(k line) of specific market.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :period Time period of K line, default to 1. You can choose between 1, 5, 15, 30, 60, 120, 240, 360, 720, 1440, 4320, 10080 (default to 1)
      # @option opts [Integer] :time_from An integer represents the seconds elapsed since Unix epoch. If set, only k-line data after that time will be returned.
      # @option opts [Integer] :time_to An integer represents the seconds elapsed since Unix epoch. If set, only k-line data till that time will be returned.
      # @option opts [Integer] :limit Limit the number of returned data points default to 30. Ignored if time_from and time_to are given. (default to 30)
      # @return [nil]
      def get_public_markets_market_k_line(market, opts = {})
        get_public_markets_market_k_line_with_http_info(market, opts)
        nil
      end

      # Get the order book of specified market.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :asks_limit Limit the number of returned sell orders. Default to 20. (default to 20)
      # @option opts [Integer] :bids_limit Limit the number of returned buy orders. Default to 20. (default to 20)
      # @return [Array<OrderBook>]
      def get_public_markets_market_order_book(market, opts = {})
        data, _status_code, _headers = get_public_markets_market_order_book_with_http_info(market, opts)
        data
      end

      # Get ticker of specific market.
      # @param market
      # @param [Hash] opts the optional parameters
      # @return [nil]
      def get_public_markets_market_tickers(market, opts = {})
        get_public_markets_market_tickers_with_http_info(market, opts)
        nil
      end

      # Get recent trades on market, each trade is included only once. Trades are sorted in reverse creation order.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :limit Limit the number of returned trades. Default to 50. (default to 50)
      # @option opts [Integer] :timestamp An integer represents the seconds elapsed since Unix epoch. If set, only trades executed before the time will be returned.
      # @option opts [Integer] :from Trade id. If set, only trades created after the trade will be returned.
      # @option opts [Integer] :to Trade id. If set, only trades created before the trade will be returned.
      # @option opts [String] :order_by If set, returned trades will be sorted in specific order, default to &#39;desc&#39;. (default to desc)
      # @return [Array<Trade>]
      def get_public_markets_market_trades(market, opts = {})
        data, _status_code, _headers = get_public_markets_market_trades_with_http_info(market, opts)
        data
      end

      # Get ticker of all markets.
      # @param [Hash] opts the optional parameters
      # @return [nil]
      def get_public_markets_tickers(opts = {})
        get_public_markets_tickers_with_http_info(opts)
        nil
      end

      # Returns list of member levels and the privileges they provide.
      # @param [Hash] opts the optional parameters
      # @return [nil]
      def get_public_member_levels(opts = {})
        get_public_member_levels_with_http_info(opts)
        nil
      end

      # Get server current time, in seconds since Unix epoch.
      # @param [Hash] opts the optional parameters
      # @return [nil]
      def get_public_timestamp(opts = {})
        get_public_timestamp_with_http_info(opts)
        nil
      end

      # Get all available markets.
      # @param [Hash] opts the optional parameters
      # @return [Array<Market>]
      def get_public_markets(opts = {})
        data, _status_code, _headers = get_public_markets_with_http_info(opts)
        data
      end

      private

      # Get list of currencies
      # @param [Hash] opts the optional parameters
      # @option opts [String] :type Currency type
      # @return [Array<(Array<Currency>, Fixnum, Hash)>] Array<Currency> data, response status code and response headers
      def get_public_currencies_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_currencies ..."
        end

        # resource path
        local_var_path = "/peatio/public/currencies"

        # query parameters
        query_params = {}
        query_params[:'type'] = opts[:'type'] if !opts[:'type'].nil?

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names,
                                                          :return_type => "Array<Currency>")

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_currencies\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        return data, status_code, headers
      end

      # Get a currency
      # @param id Currency code.
      # @param [Hash] opts the optional parameters
      # @return [Array<(Currency, Fixnum, Hash)>] Currency data, response status code and response headers
      def get_public_currencies_id_with_http_info(id, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_currencies_id ..."
        end

        # resource path
        local_var_path = "/peatio/public/currencies/{id}".sub("{" + "id" + "}", id.to_s)

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}

        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names,
                                                          :return_type => "Currency")

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_currencies_id\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        return data, status_code, headers
      end

      # Returns deposit fees for currencies.
      # @param [Hash] opts the optional parameters
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_fees_deposit_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_fees_deposit ..."
        end

        # resource path
        local_var_path = "/peatio/public/fees/deposit"

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_fees_deposit\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        return data, status_code, headers
      end

      # Returns trading fees for markets.
      # @param [Hash] opts the optional parameters
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_fees_trading_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_fees_trading ..."
        end

        # resource path
        local_var_path = "/peatio/public/fees/trading"

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_fees_trading\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        return data, status_code, headers
      end

      # Returns withdraw fees for currencies.
      # @param [Hash] opts the optional parameters
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_fees_withdraw_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_fees_withdraw ..."
        end

        # resource path
        local_var_path = "/peatio/public/fees/withdraw"

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}

        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_fees_withdraw\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        return data, status_code, headers
      end

      # Get all available markets.
      # @param [Hash] opts the optional parameters
      # @return [Array<(Array<Market>, Fixnum, Hash)>] Array<Market> data, response status code and response headers
      def get_public_markets_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_markets ..."
        end

        # resource path
        local_var_path = "/peatio/public/markets"

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names,
                                                          :return_type => "Array<Market>")

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_markets\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        return data, status_code, headers
      end

      # Get depth or specified market. Both asks and bids are sorted from highest price to lowest.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :limit Limit the number of returned price levels. Default to 300.
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_markets_market_depth_with_http_info(market, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_markets_market_depth ..."
        end

        # resource path
        local_var_path = "/peatio/public/markets/{market}/depth".sub("{" + "market" + "}", market.to_s)

        # query parameters
        query_params = {}
        query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

        # header parameters
        header_params = {}

        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)
        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_markets_market_depth\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end
        return data, status_code, headers
      end

      # Get OHLC(k line) of specific market.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :period Time period of K line, default to 1. You can choose between 1, 5, 15, 30, 60, 120, 240, 360, 720, 1440, 4320, 10080
      # @option opts [Integer] :time_from An integer represents the seconds elapsed since Unix epoch. If set, only k-line data after that time will be returned.
      # @option opts [Integer] :time_to An integer represents the seconds elapsed since Unix epoch. If set, only k-line data till that time will be returned.
      # @option opts [Integer] :limit Limit the number of returned data points default to 30. Ignored if time_from and time_to are given.
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_markets_market_k_line_with_http_info(market, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_markets_market_k_line ..."
        end

        # resource path
        local_var_path = "/peatio/public/markets/{market}/k-line".sub("{" + "market" + "}", market.to_s)

        # query parameters
        query_params = {}
        query_params[:'period'] = opts[:'period'] if !opts[:'period'].nil?
        query_params[:'time_from'] = opts[:'time_from'] if !opts[:'time_from'].nil?
        query_params[:'time_to'] = opts[:'time_to'] if !opts[:'time_to'].nil?
        query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)
        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_markets_market_k_line\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end
        return data, status_code, headers
      end

      # Get the order book of specified market.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :asks_limit Limit the number of returned sell orders. Default to 20.
      # @option opts [Integer] :bids_limit Limit the number of returned buy orders. Default to 20.
      # @return [Array<(Array<OrderBook>, Fixnum, Hash)>] Array<OrderBook> data, response status code and response headers
      def get_public_markets_market_order_book_with_http_info(market, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_markets_market_order_book ..."
        end

        # resource path
        local_var_path = "/peatio/public/markets/{market}/order-book".sub("{" + "market" + "}", market.to_s)

        # query parameters
        query_params = {}
        query_params[:'asks_limit'] = opts[:'asks_limit'] if !opts[:'asks_limit'].nil?
        query_params[:'bids_limit'] = opts[:'bids_limit'] if !opts[:'bids_limit'].nil?

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names,
                                                          :return_type => "Array<OrderBook>")
        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_markets_market_order_book\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end
        return data, status_code, headers
      end

      # Get ticker of specific market.
      # @param market
      # @param [Hash] opts the optional parameters
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_markets_market_tickers_with_http_info(market, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_markets_market_tickers ..."
        end

        # resource path
        local_var_path = "/peatio/public/markets/{market}/tickers".sub("{" + "market" + "}", market.to_s)

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)
        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_markets_market_tickers\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end
        return data, status_code, headers
      end

      # Get recent trades on market, each trade is included only once. Trades are sorted in reverse creation order.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :limit Limit the number of returned trades. Default to 50.
      # @option opts [Integer] :timestamp An integer represents the seconds elapsed since Unix epoch. If set, only trades executed before the time will be returned.
      # @option opts [Integer] :from Trade id. If set, only trades created after the trade will be returned.
      # @option opts [Integer] :to Trade id. If set, only trades created before the trade will be returned.
      # @option opts [String] :order_by If set, returned trades will be sorted in specific order, default to &#39;desc&#39;.
      # @return [Array<(Array<Trade>, Fixnum, Hash)>] Array<Trade> data, response status code and response headers
      def get_public_markets_market_trades_with_http_info(market, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_markets_market_trades ..."
        end

        # resource path
        local_var_path = "/peatio/public/markets/{market}/trades".sub("{" + "market" + "}", market.to_s)

        # query parameters
        query_params = {}
        query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
        query_params[:'timestamp'] = opts[:'timestamp'] if !opts[:'timestamp'].nil?
        query_params[:'from'] = opts[:'from'] if !opts[:'from'].nil?
        query_params[:'to'] = opts[:'to'] if !opts[:'to'].nil?
        query_params[:'order_by'] = opts[:'order_by'] if !opts[:'order_by'].nil?

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names,
                                                          :return_type => "Array<Trade>")
        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_markets_market_trades\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end
        return data, status_code, headers
      end

      # Get ticker of all markets.
      # @param [Hash] opts the optional parameters
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_markets_tickers_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_markets_tickers ..."
        end
        # resource path
        local_var_path = "/peatio/public/markets/tickers"

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)
        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_markets_tickers\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end
        return data, status_code, headers
      end

      # Returns list of member levels and the privileges they provide.
      # @param [Hash] opts the optional parameters
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_member_levels_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_member_levels ..."
        end
        # resource path
        local_var_path = "/peatio/public/member-levels"

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)
        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_member_levels\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end
        return data, status_code, headers
      end

      # Get server current time, in seconds since Unix epoch.
      # @param [Hash] opts the optional parameters
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def get_public_timestamp_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug "Calling API: PublicApi.get_public_timestamp ..."
        end

        # resource path
        local_var_path = "/peatio/public/timestamp"

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params["Accept"] = @api_client.select_header_accept(["application/json"])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          :header_params => header_params,
                                                          :query_params => query_params,
                                                          :form_params => form_params,
                                                          :body => post_body,
                                                          :auth_names => auth_names)

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: PublicApi#get_public_timestamp\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        return data, status_code, headers
      end
    end
  end
end
