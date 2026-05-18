module Backoffice
  class BaseController < ApplicationController
    layout "backoffice"
    before_action :require_login

    private

    def require_login
      redirect_to backoffice_login_path, alert: "You must sign in to continue." unless current_user
    end

    def require_nomad!
      return if current_user&.nomad?
      redirect_to backoffice_messages_path,
        alert: "That section is only available for Nomad members."
    end
  end
end
