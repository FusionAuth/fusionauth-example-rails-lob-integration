# README

This application uses the Lob and FusionAuth APIs to verify a user's home address.

## Prereqs

* FusionAuth installed with an API key
* At least the developer edition (for the registration forms), and an activated reactor
* A lob.com account with an API key

## Set up

### Envt

You need to set these variables:

```
export HMAC_SECRET=... # get from FusionAuth keymaster
export FA_API_KEY=... # setup a key
export LOB_API_KEY=... # get from Lob
```

### Rails

Run bundle install

`rails db:migrate`, this creates some forms

`rails s -b 0.0.0.0`

### FusionAuth

set up an application in FusionAuth. Set the oauth config to be `http://localhost:3000/oauth2-callback` for the redirect url and `http://localhost:3000` for the logout url.

Optionally add the first and last name fields to the registration form.

set up a webhook to respond to the user.registration.create event, and point it to `http://localhost:3000/registration_webhook`. Configure the tenant to do the same.

Optionally add the following to the default messages file for your theme. this populates the tooltips on the registration page

```
user.email=Email
user.password=Password
user.birthDate=Birthdate
user.firstName=First name
user.lastName=Last name
user.data.streetaddress1=Address line 1
user.data.streetaddress2=Address line 2
user.data.zipcode=Zip code
```

## Test it out

Using an incognito window, go to http://localhost:3000

Register a user 

View the user's data in the admin panel, you'll see the code

Log into lob and you should see a test letter sent

As the user, verify your account using the code

View the user's data in the admin panel, you'll see verification status has changed

## Next steps

* Make it look good.
* Actually send the letter instead of the test letter.
* Move the bulk of the webhook into a active job or sidekiq job.
* Figure out log out, which doesn't work smoothly
* Actually display some 'home address verified' protected info
