# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Assignment.create([
  {
    :date => Date.parse('2009/11/27'),
    :text => "Many signs are immediately recognizable, but if you get in close you might find something new. Try it!",
    :tag => "ds12"
  },
  {
    :date => Date.parse('2009/11/26'),
    :text => "It's Thanksgiving in the US. What are you thankful for? Make a photograph and share it with the world.",
    :tag => "ds11"
  },
  {
    :date => Date.parse('2009/11/25'),
    :text => "Let's play with movement today. Get a shot of something in motion. Freeze it or let it blur. It's up to you!",
    :tag => "ds10"
  },
  {
    :date => Date.parse('2009/11/24'),
    :text => "You might not be next to an ocean, but surely you can find some water around you to take a photo of.",
    :tag => "ds9"
  },
  {
    :date => Date.parse('2009/11/23'),
    :text => "How do ants see the world? Change your viewpoint. Make a photograph with your camera at floor level",
    :tag => "ds8"
  }
])