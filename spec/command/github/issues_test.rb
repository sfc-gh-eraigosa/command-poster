require "spec_helper"

# docs: https://relishapp.com/rspec/rspec-expectations/v/3-6/docs/built-in-matchers/equality-matchers
RSpec.describe Command::GitHub::Issues do
  let (:test_org) { "octocat" }
  let (:test_project) { "Hello-World" }
  before :each do
    @issues = Command::GitHub::Issues.new(test_org, test_project)
  end

  describe '#issues' do
    it '#new object' do
      expect(@issues).not_to be nil
    end

    it '#org has attribute' do
      expect(@issues).to respond_to(:org)
      expect(@issues.org).to eq test_org
    end

    it '#project has attribute' do
      expect(@issues).to respond_to(:project)
      expect(@issues.project).to eq test_project
    end

    it '#issues has private attribute array' do
      expect(@issues).not_to respond_to(:issues)
    end

    it '#getlatest has method' do
      expect(@issues).to respond_to(:getlatest)
    end

    it '#getlatest validate results' do
      VCR.use_cassette('command-github-issues') do
        expect(@issues.getlatest).to be_a(Array)
        expect(@issues.getlatest[0]).to be_a(Hash)
      end
    end

    it '#count greater than zero' do
      VCR.use_cassette('command-github-issues') do
        expect(@issues.count).to be > 0
      end
    end

    it '#list_urls gets all issue urls' do
      VCR.use_cassette('command-github-issues') do
        expect(@issues.list_urls).to be_a(Array)
      end
    end

    it '#list_titles gets all issue titles' do
      VCR.use_cassette('command-github-issues') do
        titles = @issues.list_titles
        expect(titles).to be_a(Array)
        expect(titles[0]).not_to be(nil)
      end
    end
  end

end
