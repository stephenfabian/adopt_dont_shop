class ApplicationController < ActionController::Base
  def welcome
  end

  def new
  end

  def show
    @application = Application.find(params[:id])

    #stephen add
    @pet_name_search_results = []
    # require 'pry'; binding.pry
    if params[:pet_name_search].present?
      @pet_name_search_results = Pet.find_by name: params[:pet_name_search]
      # require 'pry'; binding.pry
    end
  end

  def create
    @application = Application.new(app_params)
    # require 'pry'; binding.pry
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
