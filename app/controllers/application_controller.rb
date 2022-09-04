class ApplicationController < ActionController::Base
  def welcome
  end

  def new
  end

  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      @pet_name_search_results = Pet.find_by(name: params[:search])
    end
  end

  def update
  #  @pet_names = Pet.search(params[:search])
      @application = Application.find(params[:id])
  #  require 'pry'; binding.pry
    if params[:search]
      @pet_names = Pet.find_by(name: params[:search])
      @application_pet = ApplicationPet.create!(pet: @pet_names,  application: @application)
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


  private

  def app_params
    params.permit(:name, :street_address, :city, :state, :zip_code)
  end

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
#<% if @application.pets.present? %>
