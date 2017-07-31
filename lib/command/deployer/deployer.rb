# Handle github issues object
require 'json'

module Command
  module Deploy
    class Deployer < Command::Poster::Client
      attr_accessor :command
      attr_accessor :app
      attr_accessor :env
      attr_accessor :branch
      attr_accessor :hosts
      def initialize(url)
        super(url)
        # @path = "/repos/#{self.org}/#{self.project}/issues"
      end

      def run(string)
        json_body = self.command_parsing(string)
        resp = self.POST(json_body)
        unless resp.code =~ /20./
          return false
        end
        true
      end

# 1. https://gist.github.com/timothywellsjr/0c7a69ead8ac9c66e9d131ef3d48be79
# 2. https://gist.github.com/timothywellsjr/36265964844812d694b3f768ac084bfc
# 3. https://gist.github.com/timothywellsjr/cfbf8204d981071bdecebf82c1d31850
# 4. https://gist.github.com/timothywellsjr/9b3e3206164f1d2866e9c65af910e590
# 5. https://gist.github.com/timothywellsjr/feb449c221a100e9f8154124c61804fd
# 6. https://gist.github.com/timothywellsjr/881560abdaedacc39587ddda82fd37b8
      def command_parsing(string)
        words = []
        json = {}
# tip parse with http://rubular.com/
        case string
          when /(hubot)\s(deploy)\s(.*)\/(.*)\s(to)\s(.*)\/(.*)/ then
            self.command   = $2
            self.app       = $3
            self.branch    = $4
            self.env       = $6
            self.hosts     = $7.split(',')
          when /(hubot)\s(deploy|migrate)\s(.*)\/(.*)\s(to)\s(.*)/ then
            self.command   = $2
            self.app       = $3
            self.branch    = $4
            self.env       = $6
          when /(hubot)\s(deploy|migrate)\s(.*)\s(to)\s(.*)/ then
            self.command   = $2
            self.app       = $3
            self.env       = $5
          else
            self.command = nil
            self.app = nil
            self.branch = nil
            self.env = nil
            self.hosts = nil
        end

        json = json.merge({ "command" => self.command }) unless self.command == nil
        json = json.merge({ "app" => self.app }) unless self.app == nil
        json = json.merge({ "env" => self.env }) unless self.env == nil
        json = json.merge({ "branch" => self.branch }) unless self.branch == nil
        json = json.merge({ "hosts" => self.hosts }) unless self.hosts == nil
        json
      end

    end
  end
end
