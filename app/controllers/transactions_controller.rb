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
    tokenRequest = RestClient.post(token_request_url)
    tokenResponse = JSON.parse tokenRequest, symbolize_names:true
    @transaction.update_attribute(:token, tokenResponse[:token])
    if @transaction.save
        if @transaction.auth_code.present? 
          flash[:success] = "Transaction was approved for #{@transaction.amount}. Your Auth Code is #{@transaction.auth_code}."
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


  def token_request_url

    
    RestClient.post('https://api.iplink.co/v1/token',
                    :headers => 'Basic api_5097F8E842F245D19DA55540E42F3BE6:secret_89f61775aba44912bb0c9a1b6cf0daa1',
                    { 'trancode' => 'create',
                      'expiration_month' => @transaction.exp_date.first(2).to_s,
                      'expiration_year' => @transaction.exp_date.last(2).prepend("20").to_s,
                      'account' => @transaction.card_number.gsub(/\s+/, "").to_s
                    }.to_json,
                    :content_type => 'application/json')
    
  end


  # def token_request_url
  #   account_expiration_month = @transaction.exp_date.first(2)
  #   account_expiration_year = @transaction.exp_date.last(2).prepend("20")
  #   account_number = @transaction.card_number.gsub(/\s+/, "")
  #   url = 'https://api.iplink.co/v1/token'
  #   request = {"data" => #{@company.token_api_key}&trancode=create&account=#{account_number}&expiration_month=#{account_expiration_month}&expiration_year=#{account_expiration_year}
    

  #   "https://api.iplink.co/v1/token.#{@company.token_api_key}&trancode=create&account=#{account_number}&expiration_month=#{account_expiration_month}&expiration_year=#{account_expiration_year}"
  # end
end
