require './coin_api'
require 'byebug'

api_key = ENV['COINAPI_KEY']

api = CoinAPIv1::Client.new(api_key: api_key)

exchanges = api.metadata_list_all_exchanges()
puts 'Exchanges'

for exchange in exchanges
  puts "Exchange ID: #{exchange[:exchange_id]}"
  puts "Exchange website: #{exchange[:website]}"
  puts "Exchange name: #{exchange[:name]}"
end

assets = api.metadata_list_all_assets

puts('Assets')
for asset in assets
  puts "Asset ID: #{asset[:asset_id]}"
  puts "Asset name: #{asset[:name]}"
  puts "Asset type (crypto?): #{asset[:type_is_crypto]}"
end

symbols = api.metadata_list_all_symbols
puts 'Symbols'

for symbol in symbols
  puts "Symbol ID: #{symbol[:symbol_id]}"
  puts "Exchange ID: #{symbol[:exchange_id]}"
  puts "Symbol type: #{symbol[:symbol_type]}"
  puts "Asset ID base: #{symbol[:asset_id_base]}"
  puts "Asset ID quote: #{symbol[:asset_id_quote]}"

  if (symbol['symbol_type'] == 'FUTURES')
    puts "Future delivery time: #{symbol[:future_delivery_time]}"
  end
  if (symbol['symbol_type'] == 'OPTION')
    puts "Option type is call: #{symbol[:option_type_is_call]}"
    puts "Option strike price: #{symbol[:option_strike_price]}"
    puts "Option contract unit: #{symbol[:option_contract_unit]}"
    puts "Option exercise style: #{symbol[:option_exercise_style]}"
    puts "Option expiration time: #{symbol[:option_expiration_time]}"
  end
end

exchange_rate = api.exchange_rates_get_specific_rate(asset_id_base: 'BTC',
                                                     asset_id_quote: 'USD')
puts "Time: #{exchange_rate[:time]}"
puts "Base: #{exchange_rate[:asset_id_base]}"
puts "Quote: #{exchange_rate[:asset_id_quote]}"
puts "Rate: #{exchange_rate[:rate]}"

last_week = DateTime.iso8601('2017-05-23').to_s
exchange_rate_last_week = api.exchange_rates_get_specific_rate(asset_id_base: 'BTC',
                                                               asset_id_quote: 'USD',
                                                               parameters: {time: last_week})

puts "Time: #{exchange_rate_last_week[:time]}"
puts "Base: #{exchange_rate_last_week[:asset_id_base]}"
puts "Quote: #{exchange_rate_last_week[:asset_id_quote]}"
puts "Rate: #{exchange_rate_last_week[:rate]}"

current_rates = api.exchange_rates_get_all_current_rates(asset_id_base: 'BTC')

for rate in current_rates
  puts "Time: #{rate[:time]}"
  puts "Quote: #{rate[:asset_id_quote]}"
  puts "Rate: #{rate[:rate]}"
end

periods = api.ohlcv_list_all_periods

for period in periods
  puts "ID: #{period[:period_id]}"
  puts "Seconds: #{period[:length_seconds]}"
  puts "Months: #{period[:length_months]}"
  puts "Unit count: #{period[:unit_count]}"
  puts "Unit name: #{period[:unit_name]}"
  puts "Display name: #{period[:display_name]}"
end

ohlcv_latest = api.ohlcv_latest_data(symbol_id: 'BITSTAMP_SPOT_BTC_USD',
                                     period_id: '1MIN')

def print_data_point(data_point)
  puts "Period start: #{data_point[:time_period_start]}"
  puts "Period end: #{data_point[:time_period_end]}"
  puts "Time open: #{data_point[:time_open]}"
  puts "Time close: #{data_point[:time_close]}"
  puts "Price open: #{data_point[:price_open]}"
  puts "Price close: #{data_point[:price_close]}"
  puts "Price low: #{data_point[:price_low]}"
  puts "Price high: #{data_point[:price_high]}"
  puts "Volume traded: #{data_point[:volume_traded]}"
  puts "Trades count: #{data_point[:trades_count]}"
end

for data_point in ohlcv_latest
  print_data_point(data_point)
end

start_of_2016 = DateTime.iso8601('2016-01-01').to_s
ohlcv_historical = api.ohlcv_historical_data(symbol_id: 'BITSTAMP_SPOT_BTC_USD',
                                             period_id: '1YRS',
                                             time_start: start_of_2016)

for data_point in ohlcv_historical
  print_data_point(data_point)
end

latest_trades = api.trades_latest_data_all

def print_trade(trade)
  puts "Symbol ID: #{trade[:symbol_id]}"
  puts "Time Exchange: #{trade[:time_exchange]}"
  puts "Time CoinAPI: #{trade[:time_coinapi]}"
  puts "UUID: #{trade[:uuid]}"
  puts "Price: #{trade[:price]}"
  puts "Size: #{trade[:bsize]}"
  puts "Taker Side: #{trade[:taker_side]}"
end

for trade in latest_trades
  print_trade(trade)
end

latest_trades_doge = api.trades_latest_data_symbol(symbol_id: 'BITTREX_SPOT_BTC_DOGE')

for trade in latest_trades_doge
  print_trade(trade)
end

historical_trades_btc = api.trades_historical_data(symbol_id: 'BITSTAMP_SPOT_BTC_USD',
                                                   time_start: start_of_2016)

for trade in historical_trades_btc
  print_trade(trade)
end

current_quotes = api.quotes_current_data_all

def print_quote(quote)
  puts "Symbol ID: #{quote[:symbol_id]}"
  puts "Time Exchange: #{quote[:time_exchange]}"
  puts "Time CoinAPI: #{quote[:time_coinapi]}"
  puts "Ask Price: #{quote[:ask_price]}"
  puts "Ask Size: #{quote[:ask_size]}"
  puts "Bid Price: #{quote[:bid_price]}"
  puts "Bid Size: #{quote[:bid_size]}"
end

for quote in current_quotes
  print_quote(quote)
  if quote.has_key? :last_trade
    puts 'Last Trade:'
    print_trade(quote[:last_trade])
  end
end

current_quote_btc_usd = api.quotes_current_data_symbol(symbol_id: 'BITSTAMP_SPOT_BTC_USD')

print_quote(current_quote_btc_usd)

if current_quote_btc_usd.has_key? :last_trade
  print_trade(current_quote_btc_usd[:last_trade])
end

quotes_latest_data = api.quotes_latest_data_all

for quote in quotes_latest_data
  print_quote(quote)
end

quotes_latest_data_btc_usd = api.quotes_latest_data_symbol(symbol_id: 'BITSTAMP_SPOT_BTC_USD')

for quote in quotes_latest_data_btc_usd
  print_quote(quote)
end

quotes_historical_data_btc_usd = api.quotes_historical_data(symbol_id: 'BITSTAMP_SPOT_BTC_USD',
                                                            time_start: start_of_2016)

for quote in quotes_historical_data_btc_usd
  print_quote(quote)
end

orderbooks_current_data = api.orderbooks_current_data_all

def print_entry(entry)
  puts "Symbol ID: #{entry[:symbol_id]}"
  puts "Time Exchange: #{entry[:time_exchange]}"
  puts "Time CoinAPI: #{entry[:time_coinapi]}"
  puts 'Asks:'
  for ask in entry[:asks]
    puts "- Price: #{ask[:price]}"
    puts "- Size: #{ask[:size]}"
  end
  puts 'Bids:'
  for bid in entry[:bids]
    puts "- Price: #{bid[:price]}"
    puts "- Size: #{bid[:size]}"
  end
end

for entry in orderbooks_current_data
  print_entry(entry)
end


orderbooks_current_data_btc_usd = api.orderbooks_current_data_symbol(symbol_id: 'BITSTAMP_SPOT_BTC_USD')

print_entry(orderbooks_current_data_btc_usd)

orderbooks_latest_data_btc_usd = api.orderbooks_latest_data(symbol_id: 'BITSTAMP_SPOT_BTC_USD')

for entry in orderbooks_latest_data_btc_usd
  print_entry(entry)
end

orderbooks_historical_data_btc_usd = api.orderbooks_historical_data(symbol_id: 'BITSTAMP_SPOT_BTC_USD',
                                                                    time_start: start_of_2016)

for entry in orderbooks_historical_data_btc_usd
  print_entry(entry)
end

