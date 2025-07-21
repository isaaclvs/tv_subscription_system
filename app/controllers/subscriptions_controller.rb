class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Subscription.includes(:customer, :plan, :package, :additional_services, :booklet).all
  end

  def show
    @subscription = Subscription.find(params[:id])
  end
end
