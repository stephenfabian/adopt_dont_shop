require 'rails_helper'

RSpec.describe 'Admin Index' do

  describe 'Admin Shelters Index - SQL Only Story' do
    it 'when I visit /admin/shelters, lists all Shelters in the system listed in reverse alphabetical order by name' do

      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

      visit "/admin/shelters"

      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end
  end

  describe 'Admin Index shelters with pending applications' do
    it 'When I visit /admin/shelters, I see the name of every shelter that has a pending application' do
      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      shelter = Shelter.create!(foster_program: TRUE, name: "Karen's Shelter", city: "Madison Heights", rank: 80)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO",status: "Pending", zip_code: "80401")
      andre = Application.create!(name: "Andre Pedro", street_address: "23445 miracle st", city: "boulder", state: "CO",status: "Pending", zip_code: "12347")
      bill = Application.create!(name: "Bill Pedro", street_address: "25 miracle st", city: "bouldor", state: "CO",status: "In progress", zip_code: "12347")

      ApplicationPet.create!(pet_id: dog.id, application_id: stephen.id)
      ApplicationPet.create!(pet_id: dog2.id, application_id: andre.id)

      visit "/admin/shelters"

      within "Shelters with Pending Applications"
      expect(page).to have_content("Stephen's Shelter")
    end
  end
end
