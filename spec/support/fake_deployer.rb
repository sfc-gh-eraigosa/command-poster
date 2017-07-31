require 'sinatra/base'

# howto: https://robots.thoughtbot.com/how-to-stub-external-services-in-tests
class FakeDeployer < Sinatra::Base
  post '/deployments' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    case "#{data['command']}:#{data['app']}:#{data['env']}:#{data['branch']}"
    when /deploy:github:production:/ # for test run.1
      status 200
    when /deploy:github:staging:mybranch/ # for test run.2
      status 200
    when /migrate:github:staging:mybranch/ # for test run.3
      status 200
    else
      status 300
    end
    data.to_json
  end

end
