require 'rails_helper'

RSpec.describe 'Admin Shelters Show Page' do
  describe 'Approving a Pet for Adoption' do
    it 'When I visit /admin/applications/:id, for every pet app is for, theres button to approve app for that pet,
    when I click button, redirected to the same page.  And the approve button is no longer shown.
    Theres indicator next to pet that theyve been approved' do

      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      shelter = Shelter.create!(foster_program: TRUE, name: "Karen's Shelter", city: "Madison Heights", rank: 80)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      dog3 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Small-dog", name: "Pete")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO",status: "Pending", zip_code: "80401")
      andre = Application.create!(name: "Andre Pedro", street_address: "23445 miracle st", city: "boulder", state: "CO",status: "Pending", zip_code: "12347")
      bill = Application.create!(name: "Bill Pedro", street_address: "25 miracle st", city: "bouldor", state: "CO",status: "In progress", zip_code: "12347")

      pet_app = ApplicationPet.create!(pet_id: dog.id, application_id: stephen.id)
      pet_app2 = ApplicationPet.create!(pet_id: dog2.id, application_id: stephen.id)
      pet_app3 = ApplicationPet.create!(pet_id: dog2.id, application_id: andre.id)

      visit "/admin/applications/#{stephen.id}"

      expect(page).to have_content("Abby")
      expect(page).to have_content("Roger")
      expect(page).to_not have_content("Pete")
      expect(page).to have_button("Approve Application for Abby")
      expect(page).to have_button("Approve Application for Roger")

      click_button("Approve Application for Abby")

      expect(current_path).to eq("/admin/applications/#{stephen.id}")
      expect(page).to have_content("Abby")
      expect(page).to_not have_button("Approve Application for Abby")

      expect(page).to have_content("Status of Pet: Approved")
      expect(page).to have_content(pet_app.status)
    end
  end

  # Rejecting a Pet for Adoption
  # As a visitor
  # When I visit an admin application show page ('/admin/applications/:id')
  # For every pet that the application is for, I see a button to reject the application for that specific pet
  # When I click that button
  # Then I'm taken back to the admin application show page
  # And next to the pet that I rejected, I do not see a button to approve or reject this pet
  # And instead I see an indicator next to the pet that they have been rejected


    it 'Rejecting a Pet for Adoption' do

      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      shelter = Shelter.create!(foster_program: TRUE, name: "Karen's Shelter", city: "Madison Heights", rank: 80)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO",status: "Pending", zip_code: "80401")
      andre = Application.create!(name: "Andre Pedro", street_address: "23445 miracle st", city: "boulder", state: "CO",status: "Pending", zip_code: "12347")
      bill = Application.create!(name: "Bill Pedro", street_address: "25 miracle st", city: "bouldor", state: "CO",status: "In progress", zip_code: "12347")

      ApplicationPet.create!(pet_id: dog.id, application_id: stephen.id)
      ApplicationPet.create!(pet_id: dog2.id, application_id: andre.id)

      visit "/admin/applications/#{andre.id}"

      expect(page).to have_content("Roger")
      expect(page).to_not have_content("Abby")
      expect(page).to have_button("Reject Application")

      click_button("Reject Application")
      expect(current_path).to eq("/admin/applications/#{andre.id}")

      within "Roger"
      expect(page).to_not have_button("Reject Application")
      expect(page).to have_content("Rejected")
    end

  describe 'Approved/Rejected Pets on one Application do not affect other Applications' do
    describe 'When there are two applications in the system for the same pet' do
      describe 'When I visit the admin application show page for one of the applications' do
        describe 'And I approve or reject the pet for that application' do
          describe 'When I visit the other applications admin show page' do
            describe 'Then I do not see that the pet has been accepted or rejected for that application' do
              describe 'And instead I see buttons to approve or reject the pet for this specific application' do

                it 'Approved/Rejected Pets on one Application do not affect other Applications, checking 1st app, approving pet' do
                  shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
                  shelter = Shelter.create!(foster_program: TRUE, name: "Karen's Shelter", city: "Madison Heights", rank: 80)
                  dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
                  dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
                  dog3 = shelter.pets.create!(adoptable: TRUE, age: 2, breed: "dalmation", name: "Bingo")
                  stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO",status: "Pending", zip_code: "80401")
                  andre = Application.create!(name: "Andre Pedro", street_address: "23445 miracle st", city: "boulder", state: "CO",status: "Pending", zip_code: "12347")
                  bill = Application.create!(name: "Bill Pedro", street_address: "25 miracle st", city: "bouldor", state: "CO",status: "In progress", zip_code: "12347")

                  pet_app = ApplicationPet.create!(pet_id: dog.id, application_id: stephen.id)
                  pet_app2 = ApplicationPet.create!(pet_id: dog.id, application_id: andre.id)

                  visit "/admin/applications/#{stephen.id}"
                  click_button("Approve Application")
                  visit "/admin/applications/#{andre.id}"

                  expect(page).to have_button("Approve Application for Abby")
                  expect(page).to have_button("Reject Application for Abby")
                  save_and_open_page
                  expect(page).to_not have_content("Status of Pet: Rejected")
                  expect(page).to_not have_content("Status of Pet: Approved")
                end
              end
            end
          end
        end
      end
    end
    
    it 'Approved/Rejected Pets on one Application do not affect other Applications, checking 2nd app, rejecting pet' do
      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      shelter = Shelter.create!(foster_program: TRUE, name: "Karen's Shelter", city: "Madison Heights", rank: 80)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      dog3 = shelter.pets.create!(adoptable: TRUE, age: 2, breed: "dalmation", name: "Bingo")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO",status: "Pending", zip_code: "80401")
      andre = Application.create!(name: "Andre Pedro", street_address: "23445 miracle st", city: "boulder", state: "CO",status: "Pending", zip_code: "12347")
      bill = Application.create!(name: "Bill Pedro", street_address: "25 miracle st", city: "bouldor", state: "CO",status: "In progress", zip_code: "12347")

      pet_app = ApplicationPet.create!(pet_id: dog.id, application_id: stephen.id)
      pet_app2 = ApplicationPet.create!(pet_id: dog.id, application_id: andre.id)

      visit "/admin/applications/#{andre.id}"
      click_button("Reject Application")
      visit "/admin/applications/#{stephen.id}"

      expect(page).to have_button("Approve Application for Abby")
      expect(page).to have_button("Reject Application for Abby")
      expect(page).to_not have_content("Status of Pet: Rejected")
      expect(page).to_not have_content("Status of Pet: Approved")
    end
  end
end
