#
# Credit: Patrick Lenz (http://github.com/scoop)
# Credit: Urban Hafner (http://github.com/ujh)
#

require 'open-uri'

class ShortURL
  attr_accessor :url
  
  def initialize(url)
    self.url = url
  end
  
  def expand
    RAILS_DEFAULT_LOGGER.debug "[ShortURL] Expanding #{url}"
    tries = 0
    uri = self.url
    prev_uri = nil
    begin
      open(uri) do |f|
        prev_uri = uri
        uri = f.base_uri.to_s
      end
    rescue OpenURI::HTTPError => e
      p [uri, e]
      if prev_uri != uri && tries < 2
        tries += 1
        uri.gsub!(/[^\w]$/,'')
        retry
      end
    end
    uri
  end
end