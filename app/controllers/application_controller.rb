class ApplicationController < ActionController::Base
  def welcome
  end

  def new
  end

  def show
    @application = Application.find(params[:id])
  end

  def create
    @application = Application.create(app_params)
    redirect_to "/applications/#{@application.id}"
  end
  private

  def app_params
    params.permit(:name, :street_address, :city, :state, :zip_code)
  end

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
