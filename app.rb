class ListBlast < Sinatra::Base
  enable :sessions

  set :github_options, {
    :scopes    => "user",
    :secret    => ENV['GITHUB_CLIENT_SECRET'],
    :client_id => ENV['GITHUB_CLIENT_ID'],
  }

  register Sinatra::Auth::Github

  helpers do
    def repos
      github_request("user/repos")
    end
  end

  get '/' do
    github_organization_authenticate!('itpresidents')
    "hi"
  end

  get '/logout' do

  end

  get '/blast' do
    # form to send email
  end

  post '/blast' do
    # send mail
  end
end