OmniAuth.config.allowed_request_methods = %i[post]
OmniAuth.config.silence_get_warning     = true

Rails.application.config.middleware.use OmniAuth::Builder do
  if ENV["GITHUB_CLIENT_ID"].present?
    provider :github,
             ENV["GITHUB_CLIENT_ID"],
             ENV["GITHUB_CLIENT_SECRET"],
             scope: "user:email"
  end

  if ENV["GOOGLE_CLIENT_ID"].present?
    provider :google_oauth2,
             ENV["GOOGLE_CLIENT_ID"],
             ENV["GOOGLE_CLIENT_SECRET"]
  end
end
