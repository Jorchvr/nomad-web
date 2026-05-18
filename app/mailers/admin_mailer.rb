class AdminMailer < ApplicationMailer
  def brute_force_alert(ip, email_tried)
    @ip          = ip
    @email_tried = email_tried
    @time        = Time.current.strftime("%Y-%m-%d %H:%M:%S UTC")
    @app_url     = "https://#{ENV.fetch('APP_HOST', 'localhost')}"

    mail(
      to:      ENV.fetch("ADMIN_EMAIL", "ramooosvr3@icloud.com"),
      subject: "[World Nomad Web] ⚠️ Brute force attempt detected"
    )
  end
end
