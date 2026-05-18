class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "noreply@worldnomadweb.com")
  layout "mailer"
end
