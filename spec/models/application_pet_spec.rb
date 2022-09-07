require 'rails_helper'

RSpec.describe ApplicationPet do
  it {should belong_to(:pet)}
  it {should belong_to(:application)}

  it 'pet_name' do

    shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
    shelter = Shelter.create!(foster_program: TRUE, name: "Karen's Shelter", city: "Madison Heights", rank: 80)
    dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
    dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
    dog3 = shelter.pets.create!(adoptable: TRUE, age: 2, breed: "dalmation", name: "Bingo")
    stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO",status: "Pending", zip_code: "80401")
    andre = Application.create!(name: "Andre Pedro", street_address: "23445 miracle st", city: "boulder", state: "CO",status: "Pending", zip_code: "12347")
    bill = Application.create!(name: "Bill Pedro", street_address: "25 miracle st", city: "bouldor", state: "CO",status: "In progress", zip_code: "12347")

    app_pet1 = ApplicationPet.create!(pet_id: dog.id, application_id: stephen.id)
    app_pet2 = ApplicationPet.create!(pet_id: dog2.id, application_id: andre.id)

    expect(app_pet1.pet_name).to eq(dog.name)
    expect(app_pet2.pet_name).to eq(dog2.name)
  end

  it 'order_by_recently_created' do
    shelter = Shelter.create!(foster_program: TRUE, name: "Stephen's Shelter", city: "Royal Oak", rank: 1)
    shelter = Shelter.create!(foster_program: TRUE, name: "Karen's Shelter", city: "Madison Heights", rank: 80)
    dog = shelter.pets.create!(adoptable: TRUE, age: 5, breed: "Shitzu", name: "Abby")
    dog2 = shelter.pets.create!(adoptable: TRUE, age: 100, breed: "Huge-dog", name: "Roger")
    stephen = Application.create!(name: "Stephen Fabian", street_address: "2303 Braun Ct", city: "Golden", state: "CO",status: "Pending", zip_code: "80401")
    andre = Application.create!(name: "Andre Pedro", street_address: "23445 miracle st", city: "boulder", state: "CO",status: "Pending", zip_code: "12347")
    bill = Application.create!(name: "Bill Pedro", street_address: "25 miracle st", city: "bouldor", state: "CO",status: "In progress", zip_code: "12347")

    app_pet2 = ApplicationPet.create!(pet_id: dog2.id, application_id: stephen.id, created_at: "2022-9-06")
    app_pet1 = ApplicationPet.create!(pet_id: dog.id, application_id: stephen.id, created_at: "2022-9-07")
    
    expect(stephen.application_pets.order_by_recently_created).to eq([app_pet1, app_pet2])
  end
end

  