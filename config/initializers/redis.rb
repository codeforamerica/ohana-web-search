if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  redis_cfg = YAML.load_file(Rails.root.join("config/redis.yml"))[Rails.env]
  REDIS = Redis.new(redis_cfg.symbolize_keys) if redis_cfg
end