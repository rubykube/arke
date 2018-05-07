
### Crypto Echanges Arbitrage strategy. Proof of concept.

#### Introduction
Proof of concept is done on two exchanges: kraken.com and quoinex.com. Both exchanges support [margin trading](https://www.investopedia.com/university/margin/ "margin trading").

#### Two principals of the arbitrage strategy:
1. The strategy is market-neutral: regardless of market fluctuation return isn’t impacted.
2. The strategy doesn’t incline to move funds between exchanges.

##### First principal is implemented via:
Issuing two hedging orders on two different exchanges.
1. Short selling on exchange with the higher market price.
2. Long buy on exchange with lower market price.

Whether markets go up or down loss on one order is hedged by the profit on another order.
We borrow (via margin trading) cryptocurrency from exchange/p2p for arbitrage. So we don't store crypto on accounts which impose market risks via market fluctuations.

##### Second principal is implemented via:
1. Having fiat balance on both exchanges.
2. After the arbitrage process ends (spread closes) we return initial margins to accounts in fiat to both accounts by closing positions on exchanges. The balances change only for 'Profit and Loss' amounts.

#### Case 1. Market goes up.
https://www.evernote.com/l/AYMk5oFeMVpOxa05JdWDPm53DZIdT7Z7OmwB/image.png

Balance on Kraken: $98.53
Balance on Quoinex: $123.343

Short sell 0.0024BTC@9292.70 on [Kraken](https://www.evernote.com/l/AYObbjV41qlPyonuyO8zjVpuMAurNTbIzf8B/image.png "Kraken")
Long buy 0.0024BTC@9250.00 on [Quoinex](https://www.evernote.com/l/AYPvD0am6JlI-peA6FtkdFFk2JaVZtbMak4B/image.png "Quoinex")
Spread: $42.7

Positions Opened Price is market price:
- highest offer in green glass of order book for Kraken.
- lowest offer in red glass of order book for Quoinex.
Kraken: order amount $22,30, Leverage x2, Initial margin $11,15
Quoinex: order amount $22,20, Leverage x2, Initial margin $11.10

Spread closes @9742.20 BTC/USD

Close position on [Kraken](https://www.evernote.com/l/AYOpIXhVy3lFOoroW9-uKYkAEaLA5OhWT1oB/image.png):
- pay market price (buy on lowest price in red glass of order book)
0.0024@9742.20, amount: $23.3, fee: $0.13 ($0.06 + $0.06 + $0.01), Profit/Loss: -$1.1 (-5.33%)
https://www.evernote.com/l/AYNRQda-c81KjKjC6S3PsQqRnIYs4b5QwsgB/image.png


Close position on [Quoinex](https://www.evernote.com/l/AYP7HMKNtrlM37KFWgI30a3IMuo_vdNlPIMB/image.png):
- pay market price (sell on highest price in green glass of order book)
0.0024@9742.20, amount: $23.3, fee: $0.009, Profit/Loss: $1.283
https://www.evernote.com/l/AYOkQOAgvelG45vzHRWI_ajY3gKHyKVwPCsB/image.png
https://www.evernote.com/l/AYNZjL7_ZkdCN4fe8ANJHmc8wvYn_4TU4jMB/image.png

Balance on Kraken: $97.32
Balance on Quoinex: $124.618

Net profit: ($124.618 + $97.32) - ($98.53 + $123.343) = $0.065

Ways to increase net profit:
1. Reduce fees by using merket buy/sell instead of long position.
2. Use exchanges with low fee for margin trading
