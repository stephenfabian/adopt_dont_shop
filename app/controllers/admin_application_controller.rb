class AdminApplicationController < ApplicationController

  # def update
  #   @application = Application.find(params[:id])
  #   require 'pry'; binding.pry
  #   @application_pet = ApplicationPet.where(application_id: params[:id]).where(params[:pet_id])
  #   @application_pet.update(status: params[:app_pet_status])

  #   redirect_to "/admin/applications/#{@application.id}"
  # end

   def app_params
    params.permit(:id, :name, :street_address, :city, :state, :zip_code)
  end
end