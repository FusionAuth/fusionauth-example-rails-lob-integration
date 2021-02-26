class RegistrationWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  def handle_registration
    if request.headers["Authorization"] != Rails.configuration.x.webhook_api_key
      head :forbidden
      return
    end
    puts params[:bac]
    head :ok
  end
end
