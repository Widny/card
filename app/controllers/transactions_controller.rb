class TransactionsController < ApplicationController


  def index
    @transactions = Transaction.all
    
  end

  def new
    @company = Company.find(params[:company_id])
    @transaction = Transaction.new
  end

  def show
   # @transaction = Transaction.where(company_id: params[:id])
   #  @company = Company.find(params[:company_id])
  end


  def create
    @company = Company.find(params[:company_id])
    @transaction = @company.transactions.new(transaction_params)
    fireflyRequest = RestClient.get(firefly_request_url)
    fireflyResponse = JSON.parse fireflyRequest, symbolize_names:true
    @transaction.update_attribute(:auth_code, fireflyResponse.first[:authorization_id_response])
    if @transaction.save
        if @transaction.auth_code.present?
          flash[:success] = "Transaction was approved for #{@transaction.amount}. Your Auth Code is #{@transaction.auth_code}"
        else
          flash[:danger] = "Transaction Declined"
        end
      redirect_to company_transactions_path(@company)
    else
      flash[:danger] = "Whoops, something went wrong. Try again"
      render :new
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:card_number, :exp_date, :cvv, :amount, :full_name, :cust_zip)
  end

  

  def firefly_request_url
   "https://cloud.touchsuite.com/api/mobile/process_manual_credit_card.json?api_key=#{@company.firefly_api_key}&active=true&authcode=&cc_holder=&amount=#{@transaction.amount}&cardnumber=#{@transaction.card_number}&expiry=#{@transaction.exp_date}&custzip=#{@transaction.cust_zip}"
  end
  # Test Card
  # CC: 3566007770017510
  # EXP: 0416
  # CVV: 123 
end
