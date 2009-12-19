require 'twitter'

class TwitterController < ApplicationController
  
  # signin will call to twitter to sign in. If user hasn't authed, twitter
  # will give them a chance to auth, then we get a redirect back to yourself
  
  # then, you can call /signin as often as you want and you'll bounce
  # through the redirects seamlessly to capture.
  
  # once you go through this process, if you check in your Twitter connections
  # at http://twitter.com/account/connections you'll see the Daily Shoot as
  # an approved application. 
  
  # try revoking yourself. Then the next time you call /twitter/signin
  # you'll have to approve again....
  
  def signin
    consumer_key=ENV['TWITTER_CONSUMER_KEY']
    consumer_secret=ENV['TWITTER_CONSUMER_SECRET']

    callback_url = url_for :controller => 'twitter', :action => 'capture'
    
    oauth = Twitter::OAuth.new(consumer_key, consumer_secret, :sign_in => true)
    request_token = oauth.request_token(:oauth_callback => callback_url)
    session['rtoken'] = request_token.token
    session['rsecret'] = request_token.secret 
    redirect_to request_token.authorize_url
  end
  
  def capture
    
    consumer_key=ENV['TWITTER_CONSUMER_KEY']
    consumer_secret=ENV['TWITTER_CONSUMER_SECRET']
    
    oauth = Twitter::OAuth.new(consumer_key, consumer_secret)
    oauth.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])
    access_token = oauth.access_token
    @twitter_client = Twitter::Base.new(oauth)
    
    session['rtoken'] = nil
    session['rsecret'] = nil
  
  end
end
