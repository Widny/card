class CompaniesController < ApplicationController

	def index 
		@companies = Company.all
	end

	def show
		@company = Company.find(params[:id])
		#@transaction = Transaction.find(params[:transaction_id])
		#@transaction = Transaction.new
		#@company = Company.where(company_)
		@transaction = Transaction.where(company_id: params[:id])
	end

	def new
		@company = Company.new
		# @transaction = Transaction.where(transaction_id: params[:id])
	end

	def edit
		@company = Company.find(params[:id])
	end

	def create 
		@company = Company.new(company_params)
		if @company.save
			redirect_to @company
		else
			render :new
		end
	end

	def update
		@company = Company.find(:params[:id])

		if @company.update(company_params)
			redirect_to @company
		else
			render 'edit'
		end
	end

	def destroy 
		@company = Company.find(params[:id])
		@company.destroy

		redirect_to companies_path
	end


	private

	def company_params
		params.require(:company).permit(:name, :firefly_api_key, :token_api_key)
	end

end
