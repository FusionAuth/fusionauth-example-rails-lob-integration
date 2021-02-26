require 'fusionauth/fusionauth_client'

class AddAddressFormFields < ActiveRecord::Migration[6.1]
  def up
    client = FusionAuth::FusionAuthClient.new(ENV['API_KEY'], Rails.configuration.x.oauth.idp_url)

    addr1_req = { 
       "field": {
                "description": "Street address 1",
                "key": "user.data.streetaddress1",
                "name": "Street address 1",
                "required": true,
		"type": "string",
		"control": "text"
	}
    }

    client.create_form_field(nil, addr1_req)

    addr2_req = { 
       "field": {
                "description": "Street address 2",
                "key": "user.data.streetaddress2",
                "name": "Street address 2",
                "required": false,
		"type": "string",
		"control": "text"
	}
    }

    client.create_form_field(nil, addr2_req)

    zip_req = { 
       "field": {
                "description": "Zip code",
                "key": "user.data.zipcode",
                "name": "Zip code",
                "required": true,
		"type": "string",
		"control": "text",
                "validator": { "enabled": true, "expression": "....." }
	}
    }

    client.create_form_field(nil, zip_req)
  end
  def down
    puts "manually remove fields, please"
  end
end
