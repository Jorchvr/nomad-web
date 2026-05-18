class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user             = user
    @confirmation_url = backoffice_confirm_email_url(token: user.confirmation_token)
    mail(to: @user.email, subject: "Confirm your World Nomad Web account")
  end
end
