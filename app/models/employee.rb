class Employee < ActiveRecord::Base
  validates :name, presence: true

  has_many :entrances
  belongs_to :punch_clock
  belongs_to :account

  def entrances_in_month_range
    month_range = Date.today.at_beginning_of_month..Date.today.at_end_of_month
    entrances.in_month_range(month_range)
  end

end
