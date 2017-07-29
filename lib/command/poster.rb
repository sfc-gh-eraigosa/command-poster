require "command/poster/version"
require "command/poster/client"
require "command/github/issues"
require "command/deployer/deployer"

module Command
  module Poster
    class Runner

      def run(string)
        Client.new('http://example.com')
              .POST({foo: string})
      end

      def get_issues()
        Client.new('https://api.github.com')
              .GET('/repos/octocat/Hello-World/issues')
      end

      def try_issues()
        issues = Command::GitHub::Issues.new('octocat', 'Hello-World')
        issues.list_titles.each do |title|
          puts title
        end
      end
    end
  end
end
