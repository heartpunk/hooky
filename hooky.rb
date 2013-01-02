require 'daemons'
require 'rest-client'
require 'json'
require 'pp'

$stdout.sync = true

SLEEP_INTERVAL = 30
API_KEY = ENV['STACK_EXCHANGE_KEY']

loop do
  params = {
    :params => {
      key: API_KEY,
      order: 'desc',
      sort: 'creation',
      tagged: 'ruby-on-rails',
      site: 'stackoverflow'
    }
  }
  response = RestClient.get 'http://api.stackexchange.com/2.1/search', params

  puts JSON.pretty_generate(JSON.parse(response.body))
  sleep SLEEP_INTERVAL
end
