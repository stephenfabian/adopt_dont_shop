require 'rails_helper' 


# As a visitor
# When I visit an admin application show page ('/admin/applications/:id')
# For every pet that the application is for, I see a button to approve the application for that specific pet
# When I click that button
# Then I'm taken back to the admin application show page
# And next to the pet that I approved, I do not see a button to approve this pet
# And instead I see an indicator next to the pet that they have been approved

RSpec.describe 'Admin Shelters Show Page' do
  describe 'Approving a Pet for Adoption' do
    it 'When I visit /admin/applications/:id, for every pet app is for, theres button to approve app for that pet,
    when I click button, redirected to the same page.  And the approve button is no longer shown.  
    Theres indicator next to pet that theyve been approved' do

      shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
      shelter = Shelter.create!(foster_program: TRUE, name: "Karen's Shelter", city: "Madison Heights", rank: 80)
      dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
      dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
      stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO",status: "Pending", zip_code: "80401")
      andre = Application.create!(name: "Andre Pedro", street_address: "23445 miracle st", city: "boulder", state: "CO",status: "Pending", zip_code: "12347")
      bill = Application.create!(name: "Bill Pedro", street_address: "25 miracle st", city: "bouldor", state: "CO",status: "In progress", zip_code: "12347")

      ApplicationPet.create!(pet_id: dog.id, application_id: stephen.id)
      ApplicationPet.create!(pet_id: dog2.id, application_id: andre.id)

      visit "/admin/applications/#{stephen.id}"

      expect(page).to have_content("Abby")
      expect(page).to_not have_content("Roger")
      expect(page).to have_button("Approve Application")

      click_button("Approve Application")
      expect(current_path).to eq("/admin/applications/#{stephen.id}")


      within "Abby"
      expect(page).to_not have_button("Approve Application")
      expect(page).to have_content("Approved")
      save_and_open_page
    end
  end
end