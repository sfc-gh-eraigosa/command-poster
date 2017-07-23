require 'uri'
require 'net/http'
require 'json'
require "command/poster/version"

module Command
  module Poster
    class Runner
      def run(string)
        uri = URI('http://example.com')
        req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
        req.body = { foo: string }.to_json
        Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
      end
    end
  end
end
