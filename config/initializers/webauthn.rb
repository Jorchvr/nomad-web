require "uri"

origin = ENV.fetch("WEBAUTHN_ORIGIN", "http://localhost:3000")

WebAuthn.configure do |config|
  config.allowed_origins = [origin]
  config.rp_id           = URI.parse(origin).host
  config.rp_name         = "World Nomad Web"
end
