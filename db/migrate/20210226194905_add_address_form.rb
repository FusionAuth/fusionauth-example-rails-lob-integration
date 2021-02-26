require 'fusionauth/fusionauth_client'

class AddAddressForm < ActiveRecord::Migration[6.1]
  def up
    client = FusionAuth::FusionAuthClient.new(ENV['FA_API_KEY'], Rails.configuration.x.oauth.idp_url)
    request = { 
       "form": {
                "name": "Home verify registration form",
                "steps": [
		   "fields": [
			"a1ce41b4-0737-11eb-ac31-b0d20dc8c686",
			"a1ce4312-0737-11eb-ac31-b0d20dc8c686",
			"98301032-dcda-4509-9bf7-10cc8dc95f79",
			"65cb75f0-ef13-48f4-a131-01df23350fa9",
			"b85eb9fb-8247-44d4-97b8-7251fa237bc8"
		   ]
		],
		"type": "registration"
	}
    }

    res = client.create_form(nil, request)
    if res.status != 200
      raise "did not succeed."
    end
  end
  def down
    puts "please rollback manually"
  end
end
