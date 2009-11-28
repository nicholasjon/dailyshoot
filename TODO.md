* RSS feed for assignments

* Pagination for photos and photogs, at a minimum

* Make sure we're handling more than one photo URL in a tweet

* Fix the TweetCollector to stop when it finds the last photo in the db

* Should we cache the photo thumbnail URLs using standard Rails caching?

* Can we somehow pull in the tweets before we started using hashtags, for
  example by using a date range.  It won't be 100% accurate, but might
  be good enough.  We could manually cull out the false positives.
