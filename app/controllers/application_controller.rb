class ApplicationController < ActionController::Base
  def welcome
  end

  def new
  end

  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      @pet_name_search_results = Pet.search(params[:search])
    end
  end

  def update
      @application = Application.find(params[:id])
    if params[:search]
      @pet_names = Pet.search(params[:search])
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
        redirect_to "/applications/#{@application.id}"
      else
        redirect_to "/applications/new"
        flash[:alert] = "Error: #{error_message(@application.errors)}"
      end
  end

  def admin_show
    @application = Application.find(params[:id])
    @application_pets = @application.application_pets.order_by_recently_created
  end

  private
  def app_params
    params.permit(:name, :street_address, :city, :state, :zip_code)
  end

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
