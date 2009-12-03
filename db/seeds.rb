# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Assignment.create([
  {
    :date => Date.parse('2009/12/02'),
    :text => "Let's play around with contrast today, to help train the eye for it. Make a photo that has contrasting colors.",
    :tag  => "ds17"
  },
  {
    :date => Date.parse('2009/12/01'),
    :text => "Doors can have a lot of character, be it in the hinges, knob, or style. Make a photo of a door you pass through today.",
    :tag  => "ds16"
  },
  {
    :date => Date.parse('2009/11/30'),
    :text => "Happy, sad, frazzled, or stuffed to the gills? Make an abstract or literal photo that expresses how you feel today.",
    :tag  => "ds15"
  },
  {
    :date => Date.parse('2009/11/29'),
    :text => "Sunday challenge time! Pattern is built on repetition, like a rhythm. Make a photo of a regular or irregular pattern.",
    :tag  => "ds14"
  },
  {
    :date => Date.parse('2009/11/28'),
    :text => "Blue suede, hiking, sneakers, and pumps. If only shoes could talk. Tell their story in a photo, either on or off someone.",
    :tag  => "ds13"
  },
  {
    :date => Date.parse('2009/11/27'),
    :text => "Many signs are immediately recognizable, but if you get in close you might find something new. Try it!",
    :tag  => "ds12"
  },
  {
    :date => Date.parse('2009/11/26'),
    :text => "It's Thanksgiving in the US. What are you thankful for? Make a photograph and share it with the world.",
    :tag  => "ds11"
  },
  {
    :date => Date.parse('2009/11/25'),
    :text => "Let's play with movement today. Get a shot of something in motion. Freeze it or let it blur. It's up to you!",
    :tag  => "ds10"
  },
  {
    :date => Date.parse('2009/11/24'),
    :text => "You might not be next to an ocean, but surely you can find some water around you to take a photo of.",
    :tag  => "ds9"
  },
  {
    :date => Date.parse('2009/11/23'),
    :text => "How do ants see the world? Change your viewpoint. Make a photograph with your camera at floor level.",
    :tag  => "ds8"
  },
  {
    :date => Date.parse('2009/11/22'),
    :text => "Sunday challenge time! Approach a total stranger and make a portrait of them. Be nice!",
    :tag  => "ds7"
  },
  {
    :date => Date.parse('2009/11/21'),
    :text => "Make a photo of the loose change you receive today. Or open up the piggy bank if you need to.",
    :tag  => "ds6"
  },
  {
    :date => Date.parse('2009/11/20'),
    :text => "Numbers are all around you. Find your favorite number and make a killer photo.",
    :tag  => "ds5"
  },
  {
    :date => Date.parse('2009/11/19'),
    :text => "Get close! Photograph an ordinary object from as close as you can manage. Fill the frame!",
    :tag  => "ds4"
  },
  {
    :date => Date.parse('2009/11/18'),
    :text => "Let's play around with composition. Give us your best rule of thirds shot. Make it obvious, then reply with a link!",
    :tag  => "ds3"
  },
  {
    :date => Date.parse('2009/11/17'),
    :text => "Out and about walking? You should be! Make a photo of a street or sidewalk scene.",
    :tag  => "ds2"
  },
  {
    :date => Date.parse('2009/11/16'),
    :text => "Today's theme is red. Red hot? Red paint? Or something else? You decide. Make your photo and then reply with a link!",
    :tag  => "ds1"
  }
])