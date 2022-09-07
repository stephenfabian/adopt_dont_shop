require 'rails_helper'

RSpec.describe 'Application Show Feature' do
  describe 'Application Show Page' do
    it 'When I visit show page, I see Applicant name, full address, description,
    names of all pets application is for(pet names link to their show page, Applications status' do

      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 8, breed: "Dinosaur", name: "Dino")
      dog3 = shelter.pets.create!(adoptable: TRUE, age: 4, breed: "Bernese", name: "Cooper")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I like dogs", status: "In Progress")
      tommy = Application.create!(name: "Tommy", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I like dogs", status: "In Progress")

      ApplicationPet.create!(pet: dog, application: stephen)
      ApplicationPet.create!(pet: dog2, application: stephen)
      ApplicationPet.create!(pet: dog3, application: tommy)

      visit("/applications/#{stephen.id}")

      within("#application_start_#{stephen.id}") do
        expect(page).to have_content("Stephen Fabian")
        expect(page).to_not have_content(tommy.name)
        expect(page).to have_content(stephen.street_address)
        expect(page).to have_content(stephen.city)
        expect(page).to have_content(stephen.state)
        expect(page).to have_content(stephen.zip_code)
        expect(page).to have_content(stephen.description)
        expect(page).to have_link("Abby")
        expect(page).to_not have_link("Dinosaur")
        expect(page).to have_content(stephen.status)
      end

      click_link("Abby")
      expect(current_path).to eq("/pets/#{dog.id}")

    end
  end

    it 'Searching for Pets for an Application' do
      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I'm awesome", status: "In Progress")

      visit("/applications/#{stephen.id}")

      within("#application_#{stephen.id}") do
      expect(page).to have_content("Search for a Pet to add to this Application")
      expect(page).to have_button("Submit")
      end

      fill_in "Search", with: "Roger"
      click_on("Submit")

      expect(current_path).to eq("/applications/#{stephen.id}")
      expect(page).to have_content(dog2.name)
      expect(page).to_not have_content(dog.name)
  end
# As a visitor
# When I visit an application's show page
# And I search for a Pet by name
# And I see the names Pets that match my search
# Then next to each Pet's name I see a button to "Adopt this Pet"
# When I click one of these buttons
# Then I am taken back to the application show page
# And I see the Pet I want to adopt listed on this application
    it 'Add a Pet to an Application' do
      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I'm awesome", status: "In Progress")

      visit("/applications/#{stephen.id}")
      fill_in "Search", with: "Roger"
      click_on("Submit")

      expect(current_path).to eq("/applications/#{stephen.id}")
      expect(page).to have_content("Roger")
      expect(page).to_not have_content(dog.name)
      expect(page).to have_button("Adopt this Pet")

      click_button("Adopt this Pet")

      expect(current_path).to eq("/applications/#{stephen.id}")
      expect(page).to have_content("Roger")
      expect(page).to_not have_content(dog.name)
    end

    it 'can submit application with pet already in it, status changes from pending to in progress' do
      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401")

      visit "/applications/#{stephen.id}"

      fill_in "Search", with: "Roger"
      click_on("Submit")
      click_button("Adopt this Pet")

      fill_in "description", with: "I like dogs"
      click_on("Submit application")

      expect(current_path).to eq("/applications/#{stephen.id}")
      expect(page).to have_content("I like dogs")
      expect(page).to have_content("Pending")
      expect(page).to_not have_content("Search")
    end
      # As a visitor
      # When I visit an application's show page
      # And I have not added any pets to the application
      # Then I do not see a section to submit my application
      it 'cant submit an application without pet' do
        shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
        dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
        dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
        stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401")

        visit "/applications/#{stephen.id}"

        expect(page).to_not have_content("Submit application")
        expect(stephen.pets).to eq([])
        expect(page).to_not have_content(dog.name)
      end

  describe 'Partial Matches for Pet Names AND Case Insensitive Matches for Pet Names' do
    it 'can find a pet with a partial AND case insensitive match from the search ' do
      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      dog3 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Rogerboy")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401")

      visit "/applications/#{stephen.id}"

      fill_in "Search", with: "rog"
      click_on("Submit")

      expect(page).to have_content("Roger")
      expect(page).to have_content("Rogerboy")
      expect(page).to_not have_content("Abby")

      fill_in "Search", with: "ab"
      click_on("Submit")
      expect(page).to have_content("Abby")
      expect(page).to_not have_content("Roger")
      expect(page).to_not have_content("Rogerboy")
    end
  end
end
