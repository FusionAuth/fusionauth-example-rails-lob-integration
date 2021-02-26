require 'fusionauth/fusionauth_client'

class ModifyApplicationToUseForm < ActiveRecord::Migration[6.1]
  def up
    client = FusionAuth::FusionAuthClient.new(ENV['FA_API_KEY'], Rails.configuration.x.oauth.idp_url)
    request = { 
       "application": {
                "registrationConfiguration": {
			"enabled": true,
			"formId": "2165a4a5-2cb3-49b3-9cde-273b2371d28e",
			"type": "advanced"
		}
	}
    }

    res = client.patch_application(Rails.configuration.x.oauth.client_id, request)
    if res.status != 200
      raise "did not succeed."
    end
  end
  def down
    puts "please rollback manually"
  end
end
