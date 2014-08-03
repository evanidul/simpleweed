Koudoku.setup do |config|
  config.webhooks_api_key = "bdf9e0b1-5ae3-4a61-ad41-9e5b520b3e79"
  config.subscriptions_owned_by = :user
  config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']
  # config.free_trial_length = 30
end
