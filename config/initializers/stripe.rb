
# Get the stripe key
if ENV['RAILS_ENV'] == 'production'
  puts 'Using Production Stripe env'
  Stripe.api_key = ENV["STRIPE_API_KEY"]
else
  puts 'Using Test Stripe env'
  Stripe.api_key = "sk_test_5XT6Ve3VgDkohMPptPsRtm6t"
end