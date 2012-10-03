def send_email(email_subject, email_body)
  Mail.defaults do
    delivery_method :smtp, {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'shep.info',
      :user_name            => ENV['GMAIL_ADDRESS'],
      :password             => ENV['GMAIL_PASSWORD'],
      :authentication       => 'plain',
      :enable_starttls_auto => true  }
  end

  email_template = ERB.new File.read('./views/email.erb')
  digest = email_template.result(binding)

  Mail.deliver do
    to ENV['DESTINATION_ADDRESS']
    from ENV['GMAIL_ADDRESS']
    subject "[RESIDENTS] #{email_subject}"
    body digest
  end
end

class ListBlast < Sinatra::Base
  enable :sessions

  set :github_options, {
    :scopes    => "user",
    :secret    => ENV['GITHUB_CLIENT_SECRET'],
    :client_id => ENV['GITHUB_CLIENT_ID'],
  }

  register Sinatra::Auth::Github
  use Rack::Flash

  helpers do
    def repos
      github_request("user/repos")
    end
  end

  get '/' do
    github_organization_authenticate!('itpresidents')
    erb :main
  end

  get '/logout' do
    logout!
    erb :loggedout
  end

  post '/blast' do
    authenticate!
    send_email(params[:email][:subject], params[:email][:body])
    redirect '/'
  end
end