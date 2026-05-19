class Backoffice::WebauthnSessionsController < ApplicationController
  layout "backoffice"

  before_action :load_pending_user

  # GET /backoffice/passkeys/verify — HTML page that triggers WebAuthn
  def show
  end

  # GET /backoffice/passkeys/challenge — JSON challenge for authentication
  def challenge
    options = WebAuthn::Credential.options_for_get(
      allow: @pending_user.webauthn_credentials.pluck(:external_id)
    )
    session[:webauthn_authentication_challenge] = options.challenge
    render json: options
  end

  # POST /backoffice/passkeys/verify — verify assertion and log in
  def create
    credential = WebAuthn::Credential.from_get(params.require(:credential).permit!.to_h)
    stored = @pending_user.webauthn_credentials.find_by!(external_id: credential.id)

    credential.verify(
      session.delete(:webauthn_authentication_challenge),
      public_key: stored.public_key,
      sign_count: stored.sign_count
    )

    stored.update!(sign_count: credential.sign_count)
    session.delete(:pending_webauthn_user_id)
    session[:user_id] = @pending_user.id

    dest = @pending_user.nomad? ? backoffice_root_path : backoffice_messages_path
    render json: { redirect_to: dest }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Credential not recognized." }, status: :unprocessable_entity
  rescue WebAuthn::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def load_pending_user
    user = User.find_by(id: session[:pending_webauthn_user_id])
    unless user
      redirect_to backoffice_login_path, alert: "Session expired. Please sign in again."
      return
    end
    @pending_user = user
  end
end
