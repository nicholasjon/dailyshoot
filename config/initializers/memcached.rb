require 'memcache'

# If we're running up on Heroku, we use their server list and namespace,
# else we use localhost and our domain as a namespace.

if ENV['HEROKU_DOMAIN']
  servers = ENV['MEMCACHE_SERVERS'].split(',')
  namespace = ENV['MEMCACHE_NAMESPACE']
  CACHE = MemCache.new(servers, :namespace => namespace)
else
  CACHE = MemCache.new(["127.0.0.1"], :namespace => "dailyshoot.com")
end