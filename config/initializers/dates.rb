ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :tweet_date => "%Y\/%m\/%d"
)

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :at => "%Y\/%m\/%d %H:%M",
  :tweet_date => "%Y\/%m\/%d"
)
