# Handle github issues object
require 'json'

module Command
  module Deploy
    class Deployer < Command::Poster::Client
      attr_accessor :command
      attr_accessor :app
      attr_accessor :env
      attr_accessor :branch
      attr_accessor :instances
      def initialize(url)
        super(url)
        # @path = "/repos/#{self.org}/#{self.project}/issues"
      end

      def run(string)
        json_body = self.command_parsing(string)
        resp = self.POST(json_body)
        if resp.code != '200'
          return false
        end
        true
      end

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
            self.instances = $7.split(',')
          when /(hubot)\s(deploy|migrate)\s(.*)\/(.*)\s(to)\s(.*)/ then
            self.command   = $2
            self.app       = $3
            self.branch    = $4
            self.env       = $6
          when /(hubot)\s(deploy|migrate)\s(.*)\s(to)\s(.*)/ then
            self.command   = $2
            self.app       = $3
            self.env       = $5
        end

        json = json.merge({ "command" => self.command }) unless self.command == nil
        json = json.merge({ "app" => self.app }) unless self.app == nil
        json = json.merge({ "env" => self.env }) unless self.env == nil
        json = json.merge({ "branch" => self.branch }) unless self.branch == nil
        json = json.merge({ "instances" => self.instances }) unless self.instances == nil
        json
      end

    end
  end
end
