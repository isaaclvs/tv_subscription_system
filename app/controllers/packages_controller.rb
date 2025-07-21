class PackagesController < ApplicationController
  before_action :set_package, only: [ :show, :edit, :update, :destroy ]

  def index
    @packages = Package.all
  end

  def show
  end

  def new
    @package = Package.new
    @plans = Plan.all
    @additional_services = AdditionalService.all
  end

  def create
    @package = Package.new(package_params.except(:additional_service_ids))

    if @package.save
      if params[:package][:additional_service_ids].present?
        service_ids = params[:package][:additional_service_ids].reject(&:blank?)
        @package.additional_services = AdditionalService.find(service_ids)
      end
      redirect_to @package, notice: "Package was successfully created."
    else
      @plans = Plan.all
      @additional_services = AdditionalService.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @plans = Plan.all
    @additional_services = AdditionalService.all
  end

  def update
    if @package.update(package_params.except(:additional_service_ids))
      if params[:package][:additional_service_ids].present?
        service_ids = params[:package][:additional_service_ids].reject(&:blank?)
        @package.additional_services = AdditionalService.find(service_ids)
      else
        @package.additional_services.clear
      end
      redirect_to @package, notice: "Package was successfully updated."
    else
      @plans = Plan.all
      @additional_services = AdditionalService.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @package.subscriptions.any?
      redirect_to packages_path, alert: "Cannot delete package with active subscriptions."
    else
      @package.destroy
      redirect_to packages_path, notice: "Package was successfully deleted."
    end
  end

  private

  def set_package
    @package = Package.find(params[:id])
  end

  def package_params
    params.require(:package).permit(:name, :plan_id, :price, additional_service_ids: [])
  end
end
