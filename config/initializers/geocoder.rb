if Rails.env == 'production'
    geocodertimeout = 5
  else
    geocodertimeout = 10
  end


Geocoder.configure(

  # geocoding service (see below for supported options):
  :lookup => :google_premier,

  # IP address geocoding service (see below for supported options):
  #:ip_lookup => :maxmind,

  # to use an API key:
  #:api_key => "...",
  :api_key => ["3MljO_KtLS9BjQ-PMp3T1WRoWbY=","gme-simpleweedllc", "simpleweed-channel"],

  # geocoding service request timeout, in seconds (default 3):
  
  :timeout => geocodertimeout,
  
  # set default units to kilometers:
  :units => :km,

  # caching (see below for details):
  #:cache => Redis.new,
  #:cache_prefix => "..."

)