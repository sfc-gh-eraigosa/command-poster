require 'sinatra/base'

# howto: https://robots.thoughtbot.com/how-to-stub-external-services-in-tests
class FakeDeployer < Sinatra::Base
  post '/deployments' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    data = "#{data['command']}:#{data['app']}:#{data['env']}:#{data['branch']}"
    case data
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

  get '/:app/buildstatus' do
    data = "#{params['app']}"
    case data
    when /github/
      status 200
    else
      status 200
    end
    status
  end

  get '/:app/:branch/buildstatus' do
    data = "#{params['app']}:#{params['branch']}"
    case data
    when /github:mybranch_422/ # checking for 422 error
      status 422
    when /github:mybranch/ # for test run.5
      status 200
    else
      status 200
    end
    status
  end

end
