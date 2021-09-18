require './coin_api'
require 'byebug'

api_key = ENV['COINAPI_KEY']

api = CoinAPIv1::Client.new(api_key: api_key)
pair = { asset_id_base: 'ETH', asset_id_quote: 'USD' }
rate = api.exchange_rates_get_specific_rate **pair
p rate[:rate]