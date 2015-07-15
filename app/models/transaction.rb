class Transaction < ActiveRecord::Base

belongs_to :company
# validates :card_number, :cvv, :exp_date, :full_name, :amount,  presence: true 
# validates :card_number, length: {minimum: 15, maximum: 20}
#attr_accessor :token

# def redeem_card_number
# 	transaction.redeem_iplink_token
# 	redeemTokenResponse = JSON.parse redeem_iplink_token, symbolize_names:true
# 	transaction.update_attribute(:card_number, redeemTokenResponse.first[:account])
# end

# def redeem_expiry
# 	transaction.redeem_iplink_token
# 	redeemTokenResponse = JSON.parse redeem_iplink_token, symbolize_names:true
# 	transaction.update_attribute(:exp_date, redeemTokenResponse.first[:expiration_month].concat(redeemTokenResponse).first[:expiration_year].delete("20"))
# end






end
