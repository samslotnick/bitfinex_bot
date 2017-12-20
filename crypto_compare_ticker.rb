# Bundler.require
require 'bundler/setup'
currencies = [ "BTC", "LTC", "ETH", "ETC", "RRT", "ZEC", "XMR", "DSH", "BCC", "BCU", "XRP", "IOT", "EOS", "SAN", "OMG", "BCH", "NEO", "ETP", "QTM", "AVT", "EDO", "BTG", "DAT", "YYW" ]
class Currency
  attr_accessor :name, :week, :month
  def initialize(name)
    @name = name
    @week = Cryptocompare::HistoHour.find(name,'USD')["Data"]
    @month = Cryptocompare::HistoDay.find(name,'USD')["Data"]
  end
  def three_hour
    @week[-1]["open"]/@week[-4]["open"]
  end
  def twenty_four
     @week[-1]["open"]/@week[-25]["open"]
  end

  def forty_eight
    @week[-1]["open"]/@week[-49]["open"]
  end

  def seventy_two
    @week[-1]["open"]/@week[-73]["open"]
  end

  def one_week
     @week[-1]["open"]/@week[0]["open"]
  end

  def one_month
    @month[-1]["open"]/@month[0]["open"]
  end

  def name
    @name
  end
end

day_buy = []
week_buy = []
month_low_buy = []
sell = []
currencies.each do |cur|
  cur = Currency.new(cur)
  # print cur.name + ": "
  # puts "     "
  # print cur.three_hour
  if cur.twenty_four >= 1.2
    day_buy.push(cur.name)
  elsif cur.one_week >= 1.3
    week_buy.push(cur.name)
  elsif cur.one_month >= 1.3 && cur.twenty_four < 0.8 || cur.three_hour < 1
    month_low_buy.push(cur.name)
  end
  # end # print x.twenty_four + x.forty_eight + x.seventy_two + x.one_week + x.one_month
end
print day_buy
print week_buy
print month_low_buy
