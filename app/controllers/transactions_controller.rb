class TransactionsController < ApplicationController
  
  helper_method :redeem_cc_from_token, :redeem_iplink_token, :redeemTokenResponse, :redeem_exp_date_from_token

  def index
    @transactions = Transaction.all   
  end

  def new
    @company = Company.find(params[:company_id])
    @transaction = Transaction.new
  end

  def new_cof_transaction
    @company = Company.find(params[:company_id])
    @transaction = @company.transactions.new  
  end

  def redeem_cc_from_token
    redeem_iplink_token
    redeemTokenResponse = JSON.parse redeem_iplink_token, symbolize_names:true
    redeemTokenResponse[:account]
  end

  def redeem_exp_date_from_token
    redeem_iplink_token
    redeemTokenResponse = JSON.parse redeem_iplink_token, symbolize_names:true
    exp_month = redeemTokenResponse[:expiration_month]
    exp_year = redeemTokenResponse[:expiration_year].slice(2..3)
    expiration_date = exp_month.concat(exp_year)
  end

  def edit_cof_transaction
    @company = Company.find(params[:company_id])
    @transaction = @company.transactions.find_or_initialize_by(id: @transaction)
    render :_edit_cof_transaction
  end

  def show
   @transaction = Transaction.find(params[:transaction_id])
   @company = Company.find(params[:company_id])
  end

  def create
    @company = Company.find(params[:company_id])
    @transaction = @company.transactions.new(transaction_params)
    if firefly_process
      if @transaction.save
        process_iplink
      end
    redirect_to company_transactions_path(@company)
    else
      flash[:danger] = "Whoops, something went wrong. Try again"
      render :new
    end
  end

  def update 
    @company = Company.find(params[:company_id])
    @transaction = @company.transactions.build(params_to_update_iplink_token)
      if @transaction.save
        process_iplink_update
        redirect_to company_path(@company)
      else
        flash[:danger] = "Whoops, somehthing went wrong. Try again"  
      end
  end


  private

  def transaction_params
    params.require(:transaction).permit(:card_number, :exp_date, :cvv, :amount, :full_name, :cust_zip, :auth_code, :token)
  end

  def params_to_update_iplink_token
    params.require(:transaction).permit(:card_number, :exp_date, :cvv, :full_name, :cust_zip)
  end

  def firefly_request_url
   "https://cloud.touchsuite.com/api/mobile/process_manual_credit_card.json?api_key=#{@company.firefly_api_key}&active=true&authcode=&cc_holder=&amount=#{@transaction.amount}&cardnumber=#{@transaction.card_number}&expiry=#{@transaction.exp_date}&custzip=#{@transaction.cust_zip}"
  end
  # Test Card
  # CC: 3566007770017510
  # EXP: 0416
  # CVV: 123 

  def firefly_process
    fireflyRequest = RestClient.get(firefly_request_url)
    fireflyResponse = JSON.parse fireflyRequest, symbolize_names:true
    @transaction.update_attribute(:auth_code, fireflyResponse.first[:authorization_id_response])
      if @transaction.auth_code.present?
        flash[:success] = "Transaction was approved for #{@transaction.amount}. Your Auth Code is #{@transaction.auth_code}."
      else
        flash[:danger] = "Transaction Declined"
      end
  end

  def token_request_url
    #setup client
    iplink = RestClient::Resource.new("https://api.iplink.co/v1/token", :headers => {
        :authorization => 'Basic ' + "#{@company.token_api_key}",
        :content_type => :json,
        :accept => :json,
    })
    begin
      #post the object 
      response = iplink.post(
        {
          :trancode => "create",
          :expiration_month => @transaction.exp_date.first(2),
          :expiration_year => @transaction.exp_date.last(2).prepend("20"),
          :account => @transaction.card_number.gsub(/\s+/, ""),
        }.to_json()              
      );
    end    
  end

  def create_iplink_token
    token_request_url 
    tokenResponse = JSON.parse token_request_url, symbolize_names:true #parse the updated iplink object and get the iplink token
    @company.update_attribute(:token, tokenResponse[:token])
  end

  def redeem_iplink_token   
    iplink = RestClient::Resource.new("https://api.iplink.co/v1/token", :headers => {
      :authorization => 'Basic ' + "#{@company.token_api_key}",
      :content_type => :json,
      :accept => :json,
    })    
    begin
      response = iplink.post(
        {
          :trancode => "redeem",
          :token => @company.token,
        }.to_json()
      );
    end
  end

  def update_iplink_token
    iplink = RestClient::Resource.new("https://api.iplink.co/v1/token", :headers => {
      :authorization => 'Basic ' + "#{@company.token_api_key}",
      :content_type => :json,
      :accept => :json,
    })
    begin
      response = iplink.post(
        {
          :trancode => "update",
          :token => @company.token,
          :account => @transaction.card_number.gsub(/\s+/, ""),
          :expiration_month => @transaction.exp_date.first(2),
          :expiration_year => @transaction.exp_date.last(2).prepend("20"),
        }.to_json()
      );
    end
  end

  def process_iplink_update
    update_iplink_token
    updateTokenResponse = JSON.parse update_iplink_token, symbolize_names:true
    if updateTokenResponse[:status] ==  "Success"
      flash[:success] = "Successfully Updated Token #{@company.token}"
    else
      flash[:danger] = "Token was not updated"
    end
  end

  def process_iplink
    if @company.token.present?
      redeem_iplink_token
      redeemTokenResponse = JSON.parse redeem_iplink_token, symbolize_names:true
      flash[:success] = "Successfully Redeemed Token #{@company.token}"   
    else
      create_iplink_token
      if @company.save
        flash[:success] = "Cheers your new token is #{@company.token}"
      else
        flash[:danger] = "Token not received"
      end
    end
  end

end

