require "spec_helper"
require 'json'

# docs: https://relishapp.com/rspec/rspec-expectations/v/3-6/docs/built-in-matchers/equality-matchers
RSpec.describe Command::Poster::Client do
  let (:test_base_url) { "https://example.com" }
  before :each do
    @client = Command::Poster::Client.new(test_base_url)
  end

  describe '#client helper' do
    it '#new object' do
      expect(@client).not_to be nil
    end

    it '#http attribute' do
      expect(@client).to respond_to(:http)
      expect(@client.http).not_to be nil
    end

    it '#uri attribute' do
      expect(@client).to respond_to(:uri)
      expect(@client.uri).not_to be nil
    end

    it '#GET does exist' do
      expect(@client).to respond_to(:GET)
    end

    it '#POST does exist' do
      expect(@client).to respond_to(:POST)
    end
  end

  describe '#client methods' do
    it '#GET simple url path' do
      VCR.use_cassette('client-get') do
        resp = @client.GET('/', nil)
        expect(resp).not_to be nil
        expect(resp.code).to eq '200'
      end
    end

    it '#POST simple url data' do
      VCR.use_cassette('client-post') do
        resp = @client.POST({ foo: 'bar' })
        expect(resp).not_to be nil
        expect(resp.code).to eq '200'
        expect(resp.body).to eq("{\"result\":\"works\"}")
        expect(JSON.parse(resp.body)['result']).to eq('works')
      end
    end
  end

end
