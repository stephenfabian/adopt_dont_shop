require 'rails_helper'

RSpec.describe 'Application Show Feature' do
  describe 'Application Show Page' do
    it 'When I visit show page, I see Applicant name, full address, description,
    names of all pets application is for(pet names link to their show page, Applications status' do

      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I like cat toes", pets: "Abby", status: "In Progress")
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

  describe 'Starting an Application' do
    it 'When I visit pet index page, see a link to "Start an Application", click link, then taken to new application page with a form.  
    WHen I fill in form with Name, Street Address, City, State, Zip, and click submit, Im taken to the new applications show page, 
    and see my name, address info, and app description.  And I see indicator App is "In Progress"' do

    shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
    dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
    stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I like cat toes", pets: "Abby", status: "In Progress")

    visit("/pets")

    expect(page).to have_link("Start an Application")
    
    click_link("Start an Application")
    

    expect(current_path).to eq("/applications/new")
    # save_and_open_page

    fill_in "Name", with: "Ron"
    fill_in "Street address", with: "1820 Sunset"
    fill_in "City", with: "Berkley"
    fill_in "State", with: "MI"
    fill_in "Zip", with: "48065"
    click_on("Submit")

    #within method
    # expect(current_path).to eq("/applications/#{stephen.id}")
    expect(current_path).to eq("/applications/#{stephen.id + 1}")
    expect(page).to have_content("Ron")
    expect(page).to have_content("1820 Sunset")
    expect(page).to have_content("Berkley")
    expect(page).to have_content("MI")
    expect(page).to have_content("48065")
    save_and_open_page
    expect(page).to have_content("In Progress")
    end
  end
end