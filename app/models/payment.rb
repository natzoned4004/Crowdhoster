# == Schema Information
# Schema version: 20130830004146
#
# Table name: payments
#
#  id                    :integer          not null, primary key
#  ct_payment_id         :string(255)
#  status                :string(255)
#  amount                :integer
#  user_fee_amount       :integer
#  admin_fee_amount      :integer
#  fullname              :string(255)
#  email                 :string(255)
#  card_type             :string(255)
#  card_last_four        :string(255)
#  card_expiration_month :string(255)
#  card_expiration_year  :string(255)
#  campaign_id           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  address_one           :string(255)
#  address_two           :string(255)
#  city                  :string(255)
#  state                 :string(255)
#  postal_code           :string(255)
#  country               :string(255)
#  quantity              :integer
#  reward_id             :integer
#  additional_info       :text
#  billing_postal_code   :string(255)
#

class Payment < ActiveRecord::Base
  attr_accessible :ct_payment_id, :status, :amount, :user_fee_amount, :admin_fee_amount, :fullname, :email,
                  :card_type, :card_last_four, :card_expiration_month, :card_expiration_year, :billing_postal_code,
                  :address_one, :address_two, :city, :state, :postal_code, :country, :quantity,
                  :additional_info

  validates :fullname, :quantity, presence: true
  validates :email, presence: true, email: true

  belongs_to :campaign
  belongs_to :reward

  def self.to_csv(options={})
    #db_columns = %w{fullname email quantity amount user_fee_amount created_at status ct_payment_id}
    csv_columns = ['Name', 'Email', 'Quantity', 'Amount', 'User Fee', 'Date',
                   'Card Type', 'Card Last Four', 'Card Expiration Month', 'Card Expiration Year', 'Billing Postal Code',
                   'Address One', 'Address Two', 'City', 'State', 'Postal Code', 'Country',
                   'Additional Info','Status', 'ID']

    CSV.generate(options) do |csv|
      csv << csv_columns
      all.each do |payment|
        csv << [payment.fullname,
                payment.email,
                payment.quantity,
                display_dollars(payment.amount),
                display_dollars(payment.user_fee_amount),
                display_date(payment.created_at),
                payment.card_type,
                payment.card_last_four,
                payment.card_expiration_month,
                payment.card_expiration_year,
                payment.billing_postal_code,
                payment.address_one,
                payment.address_two,
                payment.city,
                payment.state,
                payment.postal_code,
                payment.country,
                payment.additional_info,
                payment.status,
                payment.ct_payment_id]
        end
      end
  end

  def update_api_data(payment)
    self.ct_payment_id = payment['id']
    self.status = payment['status']
    self.amount = payment['amount']
    self.user_fee_amount = payment['user_fee_amount']
    self.admin_fee_amount = payment['admin_fee_amount']
    self.card_type = payment['card']['card_type']
    self.card_last_four = payment['card']['last_four']
    self.card_expiration_month = payment['card']['expiration_month']
    self.card_expiration_year = payment['card']['expiration_year']
  end

  def self.display_dollars(amount)
    "$#{(amount.to_f/100.0).round(2)}"
  end

  def self.display_date(date)
    date.strftime("%m/%d/%Y")
  end

end
