require 'uri'
require 'net/http'
require 'json'
# cheat sheet https://github.com/augustl/net-http-cheat-sheet
module Command
  module Poster
    class Client
      attr_accessor :http
      attr_accessor :uri

      def initialize(url)
        self.uri = URI.parse(url)
        self.http = Net::HTTP.new(self.uri.host, self.uri.port)
        self.http.use_ssl = true if url =~ /^https.*/
        # ignore
        # self.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        # or verify pem file
        # pem = File.read("/path/to/my.pem")
        # http.cert = OpenSSL::X509::Certificate.new(pem)
        # http.key = OpenSSL::PKey::RSA.new(pem)
        # http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      end

      def POST(json_body = {}, params = nil)
        req = Net::HTTP::Post.new(self.uri, initheader = {'Content-Type' =>'application/json'})
        req.body = json_body.to_json
        if params != nil
          req.set_form_data(params)
        end
        self.http.start do | h |
          h.request(req)
        end
      end

      def GET(path = "/", params = nil )
        path = [path,URI.encode_www_form(params)].join('?') if params != nil
        self.http.request(Net::HTTP::Get.new(path))
      end

# TODO
# request = Net::HTTP::Put.new("/users/1")
# request.set_form_data({"users[login]" => "changed"})
# response = http.request(request)
#
# request = Net::HTTP::Delete.new("/users/1")
# response = http.request(request)
      :private
    end
  end
end
