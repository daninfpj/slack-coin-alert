require 'json'
require 'net/http'
require 'logger'

$logger = Logger.new('alert.log')

class Settings
  def self.read
    JSON.parse(open('./settings.json').read)
  end

  def self.write(settings)
  end
end

class Coin
  attr_reader :symbol, :amount

  def initialize(symbol, settings)
    @symbol = symbol
    @min = settings[0]
    @max = settings[1]
    @range = (@min..@max)
  end

  def amount=(value)
    @amount = value

    $logger.info "#{@symbol}: #{@amount}"

    notify unless @range.include?(@amount)
  end

  def notify
    SlackBot.notify("#{@symbol} is at $#{sprintf("%0.2f", @amount).gsub(/(\d)(?=\d{3}+\.)/, '\1,')}!")

    $logger.info "Sent slack notification"
  end
end

class SlackBot
  WEBHOOK_URL = ENV.fetch('SLACK_COIN_URL')

  def self.notify(message)
    Net::HTTP.post_form(URI(WEBHOOK_URL), payload: { text: message }.to_json, 'Content-Type': 'application/json')
  end
end

settings = Settings.read

['BTC', 'ETH'].each do |symbol|
  coin = Coin.new(symbol, settings[symbol])

  response = Net::HTTP.get(URI("https://api.coinbase.com/v2/prices/#{coin.symbol}-USD/spot"))
  data = JSON.parse(response)
  coin.amount = data['data']['amount'].to_f
end
