class ChargesController < ApplicationController
  def new
  end

  def create

    # Amount in cents

    @amount = 500

    # Create charge object to cross reference Telegram sign ups

    Charge.create!(
      :email => params[:stripeEmail],
      :amount => @amount
    )

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source => params[:stripeToken]
    )

    ## push all users emails into an array.
    ## cross reference the email provided in telegram up against the array.

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'idea dojo customer',
      :currency    => 'usd'
    )

    UserMailer.welcome_email(params[:stripeEmail]).deliver_now

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end

end
