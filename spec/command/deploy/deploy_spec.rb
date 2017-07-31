require "spec_helper"

RSpec.describe Command::Deploy do
  let (:command) { "hubot deploy github to production" }
  let (:url) { "https://myappsite.com/deployments" }
  before :each do
    @deployer = Command::Deploy::Deployer.new(url)
    stub_request(:any, /myappsite.com/).to_rack(FakeDeployer)
    # stub_request(:post, /myappsite.com\/deployments/).
    #    with(body: "{\"command\":\"deploy\", \"app\":\"github\", \"env\":\"production\"}",
    #         headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Host'=>'myappsite.com', 'User-Agent'=>'Ruby'}).
    #    to_return(status: 200, body: "done", headers: {})
  end

  it '#run 1. hutbot deploy github to production' do
    ret = @deployer.run("hubot deploy github to production")
    expect(ret).to be true
  end

  it '#run 1. hutbot empty command should fail' do
    ret = @deployer.run('')
    expect(ret).to be false
  end

  it '#run 2. hubot deploy github/mybranch to staging' do
    ret = @deployer.run("hubot deploy github/mybranch to staging")
    expect(ret).to be true
  end

  it '#run 3. hubot migrate github/mybranch to staging' do
    ret = @deployer.run("hubot migrate github/mybranch to staging")
    expect(ret).to be true
  end

  it '#deployer should not be empty' do
    expect(@deployer).not_to be nil
  end

  it '#run has method' do
    expect(@deployer).to respond_to(:run)
  end

  it '#app has attribute' do
    expect(@deployer).to respond_to(:app)
  end

  it '#env has attribute' do
    expect(@deployer).to respond_to(:env)
  end

  it '#branch has attribute' do
    expect(@deployer).to respond_to(:branch)
  end

  it 'should execute run' do
    VCR.use_cassette('command-deployer-run') do
      expect(@deployer.run(command)).to be true
    end
  end

  it '#command_parsing should work' do
    expect(@deployer.command_parsing("").to_json).to eq "{}"
  end

  it '#command_parsing question 1' do
    expect(@deployer.command_parsing("hubot deploy github to production")
      .to_json).to eq "{\"command\":\"deploy\",\"app\":\"github\",\"env\":\"production\"}"
  end

  it '#command_parsing question 2' do
    expect(@deployer.command_parsing("hubot deploy github/mybranch to staging")
      .to_json).to eq "{\"command\":\"deploy\",\"app\":\"github\",\"env\":\"staging\",\"branch\":\"mybranch\"}"
  end

  it '#command_parsing question 3' do
    expect(@deployer.command_parsing("hubot migrate github/mybranch to staging")
      .to_json).to eq "{\"command\":\"migrate\",\"app\":\"github\",\"env\":\"staging\",\"branch\":\"mybranch\"}"
  end

  it '#command_parsing question 4' do
    expect(@deployer
           .command_parsing("hubot deploy github/github to production/github-staff1,github-fe136")
           .to_json).to eq "{\"command\":\"deploy\",\"app\":\"github\",\"env\":\"production\",\"branch\":\"github\",\"hosts\":[\"github-staff1\",\"github-fe136\"]}"
  end

  it '#command_parsing question 5' do
    expect(@deployer
           .command_parsing("hubot deploy github/mybranch to production")
           .to_json).to eq "{\"command\":\"deploy\",\"app\":\"github\",\"env\":\"production\",\"branch\":\"mybranch\"}"
  end

  # it '#command_parsing question 6' do
  #   expect(@deployer
  #          .command_parsing("hubot deploy github/mybranch to production")
  #          .to_json).to eq "{\"app\":\"github\",\"environment\":\"production",\"branch": "mybranch", }"
  # end
end
