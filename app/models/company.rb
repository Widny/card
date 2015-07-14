class Company < ActiveRecord::Base

	has_many :transactions, dependent: :destroy

end
