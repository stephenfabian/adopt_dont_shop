require 'rails_helper'

  RSpec.describe 'Starting an Application' do
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
    expect(page).to have_content("In Progress")
    end

#     Starting an Application, Form not Completed

# As a visitor
# When I visit the new application page
# And I fail to fill in any of the form fields
# And I click submit
# Then I am taken back to the new applications page
# And I see a message that I must fill in those fields.

    describe 'Starting an Application, Form not Completed' do
      it 'fail to fill in any of form fields, get prompted by flash message' do
        shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
        dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
        stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO", zip_code: "80401", description: "I like cat toes", pets: "Abby", status: "In Progress")

        visit "/applications/new" 

        fill_in "Name", with: "Ron"
        fill_in "Street address", with: "1820 Sunset"
        fill_in "City", with: "Berkley"
        fill_in "State", with: "MI"
        click_on("Submit")

        # save_and_open_page
        # expect(current_path).to eq("/applications/#{stephen.id + 1}")
        expect(current_path).to eq("/applications/new")
        expect(page).to have_content("Error")

    end
  end
end