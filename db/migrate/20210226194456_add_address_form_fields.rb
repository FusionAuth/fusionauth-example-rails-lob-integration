require 'fusionauth/fusionauth_client'

class AddAddressFormFields < ActiveRecord::Migration[6.1]
  def up
    client = FusionAuth::FusionAuthClient.new(ENV['FA_API_KEY'], Rails.configuration.x.oauth.idp_url)

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

    res = client.create_form_field(nil, addr1_req)
    if res.status != 200
      raise "did not succeed."
    end

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

    res = client.create_form_field(nil, addr2_req)
    if res.status != 200
      raise "did not succeed."
    end

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

    res = client.create_form_field(nil, zip_req)
    if res.status != 200
      raise "did not succeed."
    end
  end
  def down
    puts "manually remove fields, please"
  end
end
