# Be sure to restart your server when you modify this file.

#the default, which serializes the session into a cookie that gets transferred back and forth
#Smellyleaf::Application.config.session_store :cookie_store, key: '_smellyleaf_session'

Smellyleaf::Application.config.session_store :active_record_store
