class ApplicationController < ActionController::Base
  def welcome
  end

  def new
  end

  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      # @pet_name_search_results = Pet.find_by(name: params[:search])
      @pet_name_search_results = Pet.search(params[:search])
    end
  end

  def update
      @application = Application.find(params[:id])
    if params[:search]
      # @pet_names = Pet.find_by(name: params[:search])
      @pet_names = Pet.search(params[:search])
      # @application_pet = ApplicationPet.create!(pet: @pet_names,  application: @application)
      @application.pets << @pet_names 
    elsif params[:description]
      @application.update(description: params[:description])
      @application.update(status: 'Pending')
    end

      redirect_to "/applications/#{@application.id}"
 end

  def create
    @application = Application.new(app_params)
      if @application.save
      # if @application.valid?
        redirect_to "/applications/#{@application.id}"
      else
        redirect_to "/applications/new"
        flash[:alert] = "Error: #{error_message(@application.errors)}"
      end
  end

  def admin_show
    @application = Application.find(params[:id])
  end

  def admin_update
    @application = Application.find(params[:id])
    @application.update(status: 'Approved') if params[:pet_id]
    redirect_to "/admin/applications/#{@application.id}"
  end
  private

  def app_params
    params.permit(:name, :street_address, :city, :state, :zip_code)
  end

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
#<% if @application.pets.present? %>
