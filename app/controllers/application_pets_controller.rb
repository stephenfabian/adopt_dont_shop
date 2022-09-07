class ApplicationPetsController < ApplicationController

  def update
    @application = Application.find(params[:application_id])
    @application_pet = ApplicationPet.find_by(application_id: params[:application_id], pet_id: params[:pet_id])
    # require 'pry'; binding.pry
    @application_pet.update(status: params[:app_pet_status])
    redirect_to "/admin/applications/#{@application.id}"
  end

  def app_pet_params
    params.permit(:status,:pet_id,:application_id)
  end

end