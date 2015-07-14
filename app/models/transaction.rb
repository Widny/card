class Transaction < ActiveRecord::Base

belongs_to :company
# validates :card_number, :cvv, :exp_date, :full_name, :amount,  presence: true 
# validates :card_number, length: {minimum: 15, maximum: 20}
#attr_accessor :token




end
