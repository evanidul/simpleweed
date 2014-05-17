# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# evanidul = User.create!(
#     :username => "evanidul",
#     :email => "evanidul@gmail.com",
#     :password => "idontreallysmoke",
#     :password_confirmation => "idontreallysmoke"
# )
# evanidul.add_role :admin # sets a global role
# evanidul.skip_confirmation!

dannerz = User.create!(
    :username => "dannerz",
    :email => "dannerz@gmail.com",
    :password => "idontreallysmoke",
    :password_confirmation => "idontreallysmoke"
)

dannerz.add_role :admin # sets a global role
dannerz.skip_confirmation!