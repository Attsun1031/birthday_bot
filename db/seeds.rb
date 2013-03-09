# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

CSV.foreach('db/birthday.csv') do |row|
  Birthday.create(:birthday => row[0], :name_en => row[1], :name_ja => row[2], :introduction => row[3], :comment => row[4], :link => row[5])
end
