require 'bundler/setup'
# require 'dotenv'
Bundler.require
symbols = ["btcusd", "ltcusd", "ethusd", "zecusd", "xmrusd", "dshusd", "xrpusd", "iotusd", "eosusd", "sanusd", "neousd", "datusd"]
def tf_value(tick)
  low = tick['low'].to_f
  last = tick['last_price'].to_f
  # av = tick['mid'].to_f
  return last / low
end
feed = []
symbols.each do |sym|
  ticker_get = 'https://api.bitfinex.com/v1/pubticker/' + sym
  url = URI(ticker_get)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(url)
  response = http.request(request)
  tick = JSON.parse(response.read_body)
  unit = Hash.new
  unit[sym[0..2]] = tf_value(tick)
  feed << unit

end

  usd = JSON.parse(File.read('orders.json'))["orders"][-1]["balance"]


feed.each do |cur|
  if cur.values[0] >= 1.3
    buy << cur
  end
end
orders = []
# print buy
if buy.length > 0
  buy.each do |ord|
      price_get = 'https://api.bitfinex.com/v1/pubticker/' + ord.keys[0] + "usd"
      url = URI(price_get)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      price = JSON.parse(response.read_body)['bid']
      balance = (100 * ord.values[0]).to_f
      units = balance / price.to_f
      order = Hash.new
      order[ord.keys[0]] = units
      orders << order
      usd -= balance
  end
end
orders.push("balance"=> usd)

File.open("./orders.json") do |f|
  f_read = f.read
  f_json = JSON.parse(f_read)
  f_json["orders"] << orders
end
