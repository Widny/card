class TransactionsController < ApplicationController

  def index
    @transaction = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create

    @transaction = Transaction.new(transaction_params)


    #Validation for CC Info here...



    fireflyRequest = RestClient.get(build_touchsuite_url_for_transaction)

    @resp = nil
    @resp = fireflyRequest if fireflyRequest


    if @resp

      @parseReq = JSON.parse @resp, symbolize_names:true

            @transaction.update_attribute(:auth_code, @parseReq.first[:authorization_id_response])
            if @transaction.save
              flash[:notice] = "Waahoo! Transaction was approved for #{@transaction.amount}. Your Auth Code is #{@transaction.auth_code}"
              redirect_to transactions_path
            else
              flash[:notice] = "Woops, something went wrong."
              render :new
            end
    else
      flash[:notice] = "Woops, Bad Call..."
      render :new
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:card_number, :exp_date, :cvv, :amount, :full_name)
  end

  def build_touchsuite_url_for_transaction
   "https://cloud.touchsuite.com/api/mobile/process_manual_credit_card.json?api_key=046AAA0614C811E389AED4BED9E2D958&active=true&authcode=&cc_holder=#{@transaction.full_name}&amount=#{@transaction.amount}&cardnumber=#{@transaction.card_number}&expiry=#{@transaction.exp_date}"
  end
  
end
