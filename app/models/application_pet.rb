class ApplicationPet < ApplicationRecord

  belongs_to :application
  belongs_to :pet

  def pet_name
    pet.name
  end
  
end