require 'rails_helper'

RSpec.describe 'Application Show Feature' do
  describe 'Application Show Page' do
    it 'When I visit show page, I see Applicant name, full address, description,
    names of all pets application is for(pet names link to their show page, Applications status' do

      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I like cat toes", status: "In Progress")

      ApplicationPet.create!(pet: dog, application: stephen)

      visit("/applications/#{stephen.id}")

      expect(page).to have_content(stephen.name)
      expect(page).to have_content(stephen.street_address)
      expect(page).to have_content(stephen.city)
      expect(page).to have_content(stephen.state)
      expect(page).to have_content(stephen.zip_code)
      expect(page).to have_content(stephen.description)
      save_and_open_page
      expect(page).to have_content("Abby")
      expect(page).to have_content(stephen.status)
    end
  end

    it 'Searching for Pets for an Application' do
      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      dog3 = shelter.pets.create!(adoptable: TRUE, age: 300, breed: "Gigantic-dog", name: "Roger")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I like cat toes", status: "In Progress")

      visit("/applications/#{stephen.id}")
      expect(page).to have_content("Search for a Pet to add to this Application")
      save_and_open_page
      fill_in "Pet name search", with: "Roger"
      click_on("Submit")

      expect(current_path).to eq("/applications/#{stephen.id}")
      expect(page).to have_content("Roger")
  end
end