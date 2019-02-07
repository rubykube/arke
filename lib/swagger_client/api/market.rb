module SwaggerClient
  module API
    class Market
      attr_accessor :api_client

      def initialize(api_client = ApiClient.default)
        @api_client = api_client
      end

      # Get your orders, results is paginated.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [String] :state Filter order by state, default to \&quot;wait\&quot; (active orders). (default to wait)
      # @option opts [Integer] :limit Limit the number of returned orders, default to 100. (default to 100)
      # @option opts [Integer] :page Specify the page of paginated results. (default to 1)
      # @option opts [String] :order_by If set, returned orders will be sorted in specific order (default to `asc`).
      # @return [Array<Order>]
      def orders(market, opts = {})
        data, _status_code, _headers = get_market_orders_with_http_info(market, opts)
        data
      end

      # Get information of specified order.
      # @param id
      # @param [Hash] opts the optional parameters
      # @return [Order]
      def order(id, opts = {})
        data, _status_code, _headers = get_market_orders_id_with_http_info(id, opts)
        data
      end

      # Get your executed trades. Trades are sorted in reverse creation order.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :limit Limit the number of returned trades. Default to 50. (default to 50)
      # @option opts [Integer] :timestamp An integer represents the seconds elapsed since Unix epoch. If set, only trades executed before the time will be returned.
      # @option opts [Integer] :from Trade id. If set, only trades created after the trade will be returned.
      # @option opts [Integer] :to Trade id. If set, only trades created before the trade will be returned.
      # @option opts [String] :order_by If set, returned trades will be sorted in specific order, default to &#39;desc&#39;. (default to desc)
      # @return [Trade]
      def trades(market, opts = {})
        data, _status_code, _headers = get_market_trades_with_http_info(market, opts)
        data
      end

      # Create a Sell/Buy order.
      # @param market
      # @param side
      # @param volume
      # @param price
      # @param [Hash] opts the optional parameters
      # @option opts [String] :ord_type  (default to limit)
      # @return [Order]
      def create_order(ord)
        pp ord
        return if ord.nil?

        data, _status_code, _headers =
          post_market_orders_with_http_info(
            ord.market.downcase,
            ord.side,
            ord.amount,
            ord.price,
            {}
          )
        data
      end

      # Cancel all my orders.
      # @param [Hash] opts the optional parameters
      # @option opts [String] :side If present, only sell orders (asks) or buy orders (bids) will be canncelled.
      # @return [Order]
      def cancel_all_orders(opts = {})
        data, _status_code, _headers = post_market_orders_cancel_with_http_info(opts)
        data
      end

      # Cancel an order.
      # @param id
      # @param [Hash] opts the optional parameters
      # @return [nil]
      def cancel_order(id, opts = {})
        post_market_orders_id_cancel_with_http_info(id, opts)
        nil
      end

      private

      # Get your orders, results is paginated.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [String] :state Filter order by state, default to \&quot;wait\&quot; (active orders).
      # @option opts [Integer] :limit Limit the number of returned orders, default to 100.
      # @option opts [Integer] :page Specify the page of paginated results.
      # @option opts [String] :order_by If set, returned orders will be sorted in specific order, default to \&quot;asc\&quot;.
      # @return [Array<(Array<Order>, Fixnum, Hash)>] Array<Order> data, response status code and response headers
      def get_market_orders_with_http_info(market, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug 'Calling API: MarketApi.get_market_orders ...'
        end

        # resource path
        local_var_path = '/peatio/market/orders'

        # query parameters
        query_params = {}
        query_params[:market] = market
        query_params[:state] = opts[:state] unless opts[:state].nil?
        query_params[:limit] = opts[:limit] unless opts[:limit].nil?
        query_params[:page] = opts[:page] unless opts[:page].nil?
        query_params[:order_by] = opts[:order_by] unless opts[:order_by].nil?

        # header parameters
        header_params = {}

        # HTTP header 'Accept' (if needed)
        header_params['Accept'] = @api_client.select_header_accept(['application/json'])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          header_params: header_params,
                                                          query_params: query_params,
                                                          form_params: form_params,
                                                          body: post_body,
                                                          auth_names: auth_names,
                                                          return_type: 'Array<Order>')

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: MarketApi#get_market_orders\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        [data, status_code, headers]
      end

      # Get information of specified order.
      # @param id
      # @param [Hash] opts the optional parameters
      # @return [Array<(Order, Fixnum, Hash)>] Order data, response status code and response headers
      def get_market_orders_id_with_http_info(id, _opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug 'Calling API: MarketApi.get_market_orders_id ...'
        end

        # resource path
        local_var_path = '/peatio/market/orders/{id}'.sub('{' + 'id' + '}', id.to_s)

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}

        # HTTP header 'Accept' (if needed)
        header_params['Accept'] = @api_client.select_header_accept(['application/json'])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          header_params: header_params,
                                                          query_params: query_params,
                                                          form_params: form_params,
                                                          body: post_body,
                                                          auth_names: auth_names,
                                                          return_type: 'Order')

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: MarketApi#get_market_orders_id\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        [data, status_code, headers]
      end

      # Get your executed trades. Trades are sorted in reverse creation order.
      # @param market
      # @param [Hash] opts the optional parameters
      # @option opts [Integer] :limit Limit the number of returned trades. Default to 50.
      # @option opts [Integer] :timestamp An integer represents the seconds elapsed since Unix epoch. If set, only trades executed before the time will be returned.
      # @option opts [Integer] :from Trade id. If set, only trades created after the trade will be returned.
      # @option opts [Integer] :to Trade id. If set, only trades created before the trade will be returned.
      # @option opts [String] :order_by If set, returned trades will be sorted in specific order, default to &#39;desc&#39;.
      # @return [Array<(Trade, Fixnum, Hash)>] Trade data, response status code and response headers
      def get_market_trades_with_http_info(market, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug 'Calling API: MarketApi.get_market_trades ...'
        end

        # resource path
        local_var_path = '/peatio/market/trades'

        # query parameters
        query_params = {}
        query_params[:market] = market
        query_params[:limit] = opts[:limit] unless opts[:limit].nil?
        query_params[:timestamp] = opts[:timestamp] unless opts[:timestamp].nil?
        query_params[:from] = opts[:from] unless opts[:from].nil?
        query_params[:to] = opts[:to] unless opts[:to].nil?
        query_params[:order_by] = opts[:order_by] unless opts[:order_by].nil?

        # header parameters
        header_params = {}
        # HTTP header 'Accept' (if needed)
        header_params['Accept'] = @api_client.select_header_accept(['application/json'])

        # form parameters
        form_params = {}

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:GET, local_var_path,
                                                          header_params: header_params,
                                                          query_params: query_params,
                                                          form_params: form_params,
                                                          body: post_body,
                                                          auth_names: auth_names,
                                                          return_type: 'Array<Trade>')

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: MarketApi#get_market_trades\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        [data, status_code, headers]
      end

      # Create a Sell/Buy order.
      # @param market
      # @param side
      # @param volume
      # @param price
      # @param [Hash] opts the optional parameters
      # @option opts [String] :ord_type
      # @return [Array<(Order, Fixnum, Hash)>] Order data, response status code and response headers
      def post_market_orders_with_http_info(market, side, volume, price, opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug 'Calling API: MarketApi.post_market_orders ...'
        end

        # resource path
        local_var_path = '/peatio/market/orders'

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}

        # HTTP header 'Accept' (if needed)
        header_params['Accept'] = @api_client.select_header_accept(['application/json'])

        # HTTP header 'Content-Type'
        header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

        pp side
        # form parameters
        post_body = {
          market: market,
          side: side == :ask ? 'buy' : 'sell',
          volume: volume,
          price: price
        }
        post_body[:ord_type] = opts[:ord_type] unless opts[:ord_type].nil?

        # http body (model)
        auth_names = []
        data, status_code, headers = @api_client.call_api(:POST, local_var_path,
                                                          header_params: header_params,
                                                          query_params: query_params,
                                                          form_params: {},
                                                          body: post_body,
                                                          auth_names: auth_names,
                                                          return_type: 'Order')

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: MarketApi#post_market_orders\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        [data, status_code, headers]
      end

      # Cancel all my orders.
      # @param [Hash] opts the optional parameters
      # @option opts [String] :side If present, only sell orders (asks) or buy orders (bids) will be canncelled.
      # @return [Array<(Order, Fixnum, Hash)>] Order data, response status code and response headers
      def post_market_orders_cancel_with_http_info(opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug 'Calling API: MarketApi.post_market_orders_cancel ...'
        end

        # resource path
        local_var_path = '/peatio/market/orders/cancel'

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}

        # HTTP header 'Accept' (if needed)
        header_params['Accept'] = @api_client.select_header_accept(['application/json'])

        # HTTP header 'Content-Type'
        header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

        # form parameters
        form_params = {}
        form_params['side'] = opts[:side] unless opts[:side].nil?

        # http body (model)
        post_body = nil
        auth_names = []
        data, status_code, headers = @api_client.call_api(:POST, local_var_path,
                                                          header_params: header_params,
                                                          query_params: query_params,
                                                          form_params: form_params,
                                                          body: post_body,
                                                          auth_names: auth_names,
                                                          return_type: 'Order')
        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: MarketApi#post_market_orders_cancel\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end
        [data, status_code, headers]
      end

      # Cancel an order.
      # @param id
      # @param [Hash] opts the optional parameters
      # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
      def post_market_orders_id_cancel_with_http_info(id, _opts = {})
        if @api_client.config.debugging
          @api_client.config.logger.debug 'Calling API: MarketApi.post_market_orders_id_cancel ...'
        end

        # resource path
        local_var_path = '/peatio/market/orders/{id}/cancel'.sub('{' + 'id' + '}', id.to_s)

        # query parameters
        query_params = {}

        # header parameters
        header_params = {}

        # HTTP header 'Accept' (if needed)
        header_params['Accept'] = @api_client.select_header_accept(['application/json'])

        # HTTP header 'Content-Type'
        header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

        # form parameters
        form_params = {}

        # http body (model)

        post_body = nil

        data, status_code, headers = @api_client.call_api(:POST, local_var_path,
                                                          header_params: header_params,
                                                          query_params: query_params,
                                                          form_params: form_params,
                                                          body: post_body,
                                                          auth_names: [])

        if @api_client.config.debugging
          @api_client.config.logger.debug "API called: MarketApi#post_market_orders_id_cancel\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
        end

        [data, status_code, headers]
      end
    end
  end
end
