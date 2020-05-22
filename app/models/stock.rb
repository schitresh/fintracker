class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.new_from_lookup(ticker_symbol)
    begin
      StockQuote::Stock.new(api_key: ENV['STOCK_KEY'])
      looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
      # byebug
      price = looked_up_stock.latest_price
      new(name: looked_up_stock.company_name, ticker: looked_up_stock.symbol, last_price: price)
      # new(name: "StockName", ticker: "SYMBOL", last_price: 100)
    rescue Exception => e
      return nil
    end
  end

  def self.strip_comma(number)
    number.gsub(",", "")
  end
end
