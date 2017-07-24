require "spec_helper"

RSpec.describe Command::Poster do
  before :each do
    @client = Command::Poster::Runner.new
  end

  context '#run' do
    let (:result_code) { "200" }
    let (:result_body) { "{\"result\":\"works\"}" }
    before do
      stub_request(:post, /example.com/).
         with(body: "{\"foo\":\"foo\"}",
              headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Host'=>'example.com', 'User-Agent'=>'Ruby'}).
         to_return(status: 200, body: "#{result_body}", headers: {})
    end

    it "has a version number" do
      expect(Command::Poster::VERSION).not_to be nil
    end

    it "gets a valid return code" do
      request = @client.run('foo')
      expect(request.code).to eq(result_code)
    end

    it "gets a good body" do
      request = @client.run('foo')
      expect(request.body).to eq(result_body)
    end

  end

  context '#get_issues' do
    let (:result_code) { "200" }

    it 'has good return code' do
      request = @client.get_issues
      expect(request.code).to eq(result_code)
    end
  end

end

describe 'happy test with vcr', :vcr => true do
  it "gets a valid return code" do
    VCR.use_cassette('command-poster-post') do
      request = Command::Poster::Runner.new.run('a vcr foo')
      expect(request.code).to eq("200")
    end
  end
end
