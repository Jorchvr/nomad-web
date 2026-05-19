class Backoffice::WebauthnCredentialsController < Backoffice::BaseController
  # GET /backoffice/passkeys/register — returns JSON challenge for registration
  def challenge
    options = WebAuthn::Credential.options_for_create(
      user: {
        id:           current_user.webauthn_id,
        name:         current_user.email,
        display_name: current_user.name
      },
      exclude: current_user.webauthn_credentials.pluck(:external_id)
    )
    session[:webauthn_creation_challenge] = options.challenge
    render json: options
  end

  # POST /backoffice/passkeys — verify and store credential
  def create
    credential = WebAuthn::Credential.from_create(params.require(:credential).permit!.to_h)
    credential.verify(session.delete(:webauthn_creation_challenge))

    current_user.webauthn_credentials.create!(
      external_id: credential.id,
      public_key:  credential.public_key,
      sign_count:  credential.sign_count,
      nickname:    params[:nickname].presence || "Passkey"
    )

    render json: { status: "ok" }
  rescue WebAuthn::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # DELETE /backoffice/passkeys/:id
  def destroy
    credential = current_user.webauthn_credentials.find(params[:id])
    credential.destroy
    redirect_to backoffice_security_path, notice: "Passkey removed."
  end
end
