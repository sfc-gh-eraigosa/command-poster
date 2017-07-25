# Handle github issues object
require 'json'

module Command
  module GitHub
    class Issues < Command::Poster::Client
      attr_accessor :org
      attr_accessor :project
      attr_reader   :path
      attr_reader   :options
      attr_accessor :json_data
      def initialize(org, project, options = {:url => 'https://api.github.com'})
        @options = options
        super(self.options[:url])
        self.org = org
        self.project = project
        @path = "/repos/#{self.org}/#{self.project}/issues"
        self.issues = []
      end

      def getlatest
        resp = self.GET(self.path)
        if resp.code == '200'
          self.json_data = JSON.parse(resp.body)
        else
          raise "Failed to get issues from #{self.options[:url]}, #{resp.code}\n
                #{resp.body}"
        end
      end

      def count
        self.getlatest
        self.json_data.length
      end

      def list_urls
        self.getlatest
        urls = []
        self.json_data.each do |issue|
          urls << issue["url"]
        end
        urls
      end

      def list_titles
        self.getlatest
        titles = []
        self.json_data.each do |issue|
          titles << issue["title"]
        end
        titles
      end

      private
      attr_accessor :issues
    end
  end
end
