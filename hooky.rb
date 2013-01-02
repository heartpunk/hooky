require 'json'
require 'em-http-request'

$stdout.sync = true

SLEEP_INTERVAL = 30
API_KEY = ENV['STACK_EXCHANGE_KEY']

URL = 'http://api.stackexchange.com/2.1/search'
PARAMS1 = {
    key: API_KEY,
    order: 'desc',
    sort: 'creation',
    tagged: 'ruby-on-rails',
    site: 'stackoverflow'
  }

PARAMS2 = {
    key: API_KEY,
    order: 'desc',
    sort: 'creation',
    tagged: 'ruby',
    site: 'stackoverflow'
  }

EventMachine.run do
  EventMachine::PeriodicTimer.new(SLEEP_INTERVAL) do
    [PARAMS1, PARAMS2].map do |params|
      # the accept headers are only necessary because of https://github.com/igrigorik/em-http-request/issues/204
      http = EventMachine::HttpRequest.new(URL).get :head => {'Accept-Encoding' => 'deflate'}, :query => params

      http.errback { raise http.response }
      http.callback { puts JSON.pretty_generate(JSON.parse(http.response)); exit }
    end
  end
end
