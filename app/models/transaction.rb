class Transaction < ActiveRecord::Base

validates :card_number, :cvv, :exp_date, :amount, presence: true
validates :card_number, length: {minimum: 15, maximum: 16}


end
