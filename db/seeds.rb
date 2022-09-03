# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Pet.destroy_all
Shelter.destroy_all

shelter10 = Shelter.create!(foster_program: TRUE, name: "John's Shelter", city: "Royal Oak", rank: 800)
dog10 = shelter10.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Rabbit")