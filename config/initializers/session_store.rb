# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_openflash_session',
  :secret      => '7c4f907b6c03e251d14045f0dc8bfd7220123648dfc4a7ea9ebed35037606590e861f8c64935d1d8e01b7a3767d3d82dee70ab83808a7be693f576b8eb496bb5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
