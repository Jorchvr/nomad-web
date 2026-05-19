class ResetAdminTwoFactorAgain < ActiveRecord::Migration[8.1]
  def up
    User.where(email: "ramoosvr3@icloud.com")
        .update_all(otp_enabled: false, otp_secret: nil)
  end

  def down; end
end
