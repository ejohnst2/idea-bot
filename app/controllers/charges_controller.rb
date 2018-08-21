class ChargesController < ApplicationController
  def new
  end

  def create

    # Amount in cents

    @amount = 500

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source => params[:stripeToken]
    )

    ## push all users emails into an array.
    ## cross reference the email provided in telegram up against the array.

    plan = Stripe::Plan.create(
      :product     => ENV.fetch("STRIPE_PRODUCT_KEY"),
      :nickname    => 'monthly subscription',
      :interval    => 'month',
      :currency    => 'usd',
      :amount      => @amount
    )

    ## subscribe the customer to the plan

    subscription = Stripe::Subscription.create(
      :customer    => customer.id,
      :items        => [{ plan: plan.id }]
    )

    ## trigger the welcome email

    UserMailer.welcome_email(params[:stripeEmail]).deliver_now

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end

end
