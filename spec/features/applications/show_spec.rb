require 'rails_helper'

RSpec.describe 'Application Show Page' do
#   As a visitor
# When I visit an applications show page
# Then I can see the following:
# - Name of the Applicant
# - Full Address of the Applicant including street address, city, state, and zip code
# - Description of why the applicant says they'd be a good home for this pet(s)
# - names of all pets that this application is for (all names of pets should be links to their show page)
# - The Application's status, either "In Progress", "Pending", "Accepted", or "Rejected"

it 'When I visit show page, I see Applicant name, full address, description,
names of all pets application is for(pet names link to their show page, Applications status' do

  shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
  dog = Pet.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby", shelter_id: shelter.id)
  stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I like cat toes", pets: dog.id, status: "In Progress")
require 'pry'; binding.pry
  visit("/applications/#{stephen.id}")

  expect(page).to have_content(stephen.name)
  expect(page).to have_content(stephen.street_address)
  expect(page).to have_content(stephen.city)
  expect(page).to have_content(stephen.state)
  expect(page).to have_content(stephen.zip_code)
  expect(page).to have_content(stephen.description)
  expect(page).to have_content(stephen.pets)
  expect(page).to have_content(stephen.status)

  end
end