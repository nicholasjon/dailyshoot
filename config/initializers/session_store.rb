# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.

ActionController::Base.session = {
  :key         => '_dailyshoot.com_session',
  :secret      => '69ed3bb75c596a568a3aa33ed6359d1310c4abae64150ffcd153932a1c9d59f5c005c25d3019d309ae1c43afb1f50d30672d0b863c1cf9462b8d0df06c1f27a3',
  :cache       => CACHE,
  :expires_after => 1.day
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
#ActionController::Base.session_store = :active_record_store

unless RAILS_ENV == 'test'
  ActionController::Base.session_store = :mem_cache_store
end