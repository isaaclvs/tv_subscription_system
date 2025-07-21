class AdditionalServicesController < ApplicationController
  def index
    @additional_services = AdditionalService.all
  end

  def show
    @additional_service = AdditionalService.find(params[:id])
  end
end
