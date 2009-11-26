* RSS feed for assignments

* Pagination for photos and photogs, at a minimum

* Make sure we're handling more than one photo URL in a tweet

* Fix the TweetCollector to stop when it finds the last photo in the db

* Should we cache the photo thumbnail URLs using standard Rails caching?

* Currently using a source_id column on Photo to keep it non-Twitter specific
  (it was previously called tweet_id).  Does it even make sense if we were to 
  use the Flickr API, too?  Not sure how we'd distinguish whether we already 
  have a photo if Flickr doesn't have a source_id equivalent.  

* Can we somehow pull in the tweets before we started using hashtags, for
  example by using a date range.  It won't be 100% accurate, but might
  be good enough.  We could manually cull out the false positives.