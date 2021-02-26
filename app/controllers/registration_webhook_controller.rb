require 'lob'
require 'fusionauth/fusionauth_client'
 
# TODO offload this to an async job 

class RegistrationWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  def handle_registration
    if request.headers["Authorization"] != Rails.configuration.x.webhook_api_key
      head :forbidden
      return
    end

    # check to see if this is correct webhook
    event_type = params[:event][:type]

    if event_type != 'user.registration.create' 
      Rails.logger.warn("misconfiguration, we got an event of type "+event_type)
      return
    end
 
    # parse user
    # TODO check registration
    user_id = params[:event][:user][:id]
    street_address1 = params[:event][:user][:data][:streetaddress1]
    street_address2 = params[:event][:user][:data][:streetaddress2]
    zip_code = params[:event][:user][:data][:zipcode]
    first_name = params[:event][:user][:firstName]
    last_name = params[:event][:user][:lastName]
   
    
    unless user_id && street_address1 && zip_code
      Rails.logger.warn("misconfiguration, we don't have address info")
      return
    end
   
    # create code
    string_length = 8
    code = rand(36**string_length).to_s(36)

    # save to user
    client = FusionAuth::FusionAuthClient.new(ENV['FA_API_KEY'], Rails.configuration.x.oauth.idp_url)
    request = {
       "user": {
                "data": {
                        "mailingAddressVerified": false,
                        "mailingAddressVerifyCode": code
                }       
        }               
    }                   
                        
    res = client.patch_user(user_id, request)
    if res.status != 200
      Rails.logger.warn("unable to save code")
      Rails.logger.warn(res.to_json)
      return
    end 
    

    # look up city,state from zip code
    city = Ziptedu.zipcode(zip_code).city
    state = Ziptedu.zipcode(zip_code).state

    # build letter
    file = %Q(
    <html style='padding-top: 3in; margin: .5in;'>
    Thank you for registering for the Home Verification App.<br/><br/>
    Please visit {{host}}/verify and enter the code: {{code}}.<br/><br/>
    - the Home Verifier Team
    </html>
    )

    cust_name = "Future Customer"
    if first_name && last_name
      cust_name = first_name + " " + last_name
    end

    lob = Lob::Client.new(api_key: ENV['LOB_API_KEY'], api_version: "2020-02-11")
    lob.letters.create(
      description: "Demo Letter",
      to: {
        name: cust_name,
        address_line1: street_address1,
        address_line2: street_address2,
        address_city: city,
        address_state: state,
        address_zip: zip_code
      },
      from: {
        name: "Dan Moore",
        address_line1: "Box 458",
        address_city: "Boulder",
        address_state: "CO",
        address_zip: "80306"
      },
      file: file,
      merge_variables: {
        code: code,
        host: "http://localhost:3000"
      },
      color: false
    )

    head :ok
  end
end
