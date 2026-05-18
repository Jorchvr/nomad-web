class Rack::Attack
  # Throttle login attempts: max 5 per IP per minute
  throttle("logins/ip", limit: 5, period: 60) do |req|
    req.ip if req.path == "/backoffice/login" && req.post?
  end

  # Throttle login attempts by email: max 5 per email per 5 minutes
  throttle("logins/email", limit: 5, period: 300) do |req|
    if req.path == "/backoffice/login" && req.post?
      req.params["email"].to_s.downcase.gsub(/\s+/, "").presence
    end
  end

  # Throttle registration: max 3 per IP per hour
  throttle("registrations/ip", limit: 3, period: 3600) do |req|
    req.ip if req.path == "/backoffice/register" && req.post?
  end

  # Block IPs with too many overall requests (basic DDoS protection)
  throttle("requests/ip", limit: 300, period: 60) do |req|
    req.ip unless req.path.start_with?("/assets")
  end

  # Send admin email alert on brute-force throttle (once per IP per 10 minutes)
  ActiveSupport::Notifications.subscribe("rack.attack") do |_name, _start, _finish, _id, payload|
    req = payload[:request]
    next unless req.env["rack.attack.match_type"] == :throttle
    next unless req.env["rack.attack.matched"].start_with?("logins/")

    ip         = req.ip
    email_tried = req.params["email"].to_s.downcase.presence

    cache_key = "brute_force_alert/#{ip}"
    unless Rails.cache.exist?(cache_key)
      Rails.cache.write(cache_key, true, expires_in: 10.minutes)
      AdminMailer.brute_force_alert(ip, email_tried).deliver_now rescue nil
    end
  end

  # Return 429 with a clear message when throttled
  self.throttled_responder = lambda do |req|
    [
      429,
      { "Content-Type" => "text/html; charset=utf-8" },
      [
        <<~HTML
          <!DOCTYPE html>
          <html>
            <body style="font-family:sans-serif;text-align:center;padding:60px;background:#f5f0e8;">
              <h2 style="color:#1a2e20;">Too many requests</h2>
              <p style="color:#4a6555;">You have made too many attempts. Please wait a moment and try again.</p>
            </body>
          </html>
        HTML
      ]
    ]
  end
end
