module Backoffice
  class TwoFactorController < ApplicationController
    layout "backoffice"
    before_action :require_login, only: [:setup, :enable, :disable]

    # Step 2 of login — verify OTP code
    def new
      redirect_to backoffice_login_path unless session[:pending_2fa_user_id]
    end

    def create
      user = User.find_by(id: session[:pending_2fa_user_id])
      unless user
        redirect_to backoffice_login_path, alert: "Session expired. Please log in again."
        return
      end

      if user.verify_otp(params[:otp_code])
        session.delete(:pending_2fa_user_id)
        session[:user_id] = user.id
        dest = user.nomad? ? backoffice_root_path : backoffice_messages_path
        redirect_to dest, notice: "Welcome back, #{user.name}!"
      else
        flash.now[:alert] = "Invalid code. Please try again."
        render :new, status: :unprocessable_entity
      end
    end

    # Setup — show QR code
    def setup
      current_user.generate_otp_secret! unless current_user.otp_secret.present?
      @qr_svg = RQRCode::QRCode.new(current_user.otp_provisioning_uri)
                               .as_svg(module_size: 5, standalone: true, use_path: true)
    end

    # Confirm setup with a valid code
    def enable
      if current_user.verify_otp(params[:otp_code])
        current_user.update!(otp_enabled: true)
        redirect_to backoffice_security_path, notice: "Two-factor authentication enabled."
      else
        flash.now[:alert] = "Invalid code. Scan the QR again and try."
        current_user.generate_otp_secret!
        @qr_svg = RQRCode::QRCode.new(current_user.otp_provisioning_uri)
                                 .as_svg(module_size: 5, standalone: true, use_path: true)
        render :setup, status: :unprocessable_entity
      end
    end

    # Disable 2FA
    def disable
      if current_user.admin?
        redirect_to backoffice_security_path, alert: "Admin accounts cannot disable two-factor authentication."
        return
      end
      current_user.update!(otp_enabled: false, otp_secret: nil)
      redirect_to backoffice_security_path, notice: "Two-factor authentication disabled."
    end

    private

    def require_login
      redirect_to backoffice_login_path, alert: "You must sign in to continue." unless current_user
    end
  end
end
