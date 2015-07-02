class CompaniesController < ApplicationController

	def index 
		@companies = Company.all

		respond_to do |format|
			format.json { render json: @comapnies}
		end
	end

	def show
		@company = Company.find(params[:id])
		#@transaction = Transaction.new
		#@company = Company.where(company_)
		@transaction = Transaction.where(company_id: params[:id])
	end

	def new
		@company = Company.new
	end

	def create 
		@company = Company.new(company_params)
		if @company.save
			redirect_to @company
		else
			render :new
		end
	end


	private

	def company_params
		params.require(:company).permit(:name, :firefly_api_key, :token_api_key)
	end

end
