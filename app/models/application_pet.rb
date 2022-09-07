class ApplicationPet < ApplicationRecord

  belongs_to :application
  belongs_to :pet

  def pet_name
    pet.name
  end

  def self.order_by_recently_created
    order(created_at: :desc)
  end
end