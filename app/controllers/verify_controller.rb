require 'fusionauth/fusionauth_client'

class VerifyController < ApplicationController
  def index
    unless logged_in?
      redirect_to root_path
    end
  end

  def success
    unless logged_in?
      redirect_to root_path
    end

  end

  def check_code
    unless logged_in?
      redirect_to root_path
    end

    client = FusionAuth::FusionAuthClient.new(ENV['FA_API_KEY'], Rails.configuration.x.oauth.idp_url)
    provided_code = params[:code]
 
    user_id = current_user["sub"] # from the claim

    res = client.retrieve_user(user_id)
    if res.status != 200
      Rails.logger.warn("Unable to get user: "+user_id)
      Rails.logger.warn(res.to_json)
    else 
      user_data = res.success_response.user.data
      puts user_data.mailingAddressVerified
      if user_data.mailingAddressVerified == true
        redirect_to verify_success_path
	return
      else 
        expected_code = user_data.mailingAddressVerifyCode
        if provided_code == expected_code
          request = {
            "user": {
                     "data": {
                             "mailingAddressVerified": true,
                             "mailingAddressVerifyCode": 0
                     }       
        	}               
    	  }                   
          res = client.patch_user(user_id, request)
          if res.status != 200
            Rails.logger.warn("unable to modify code")
            Rails.logger.warn(res.to_json)
            return
          end 
          redirect_to verify_success_path
	  return
        else
          redirect_to verify_path
	  return
        end
      end
    end

    redirect_to verify_path
  end
end
