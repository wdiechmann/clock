class Entrance < ActiveRecord::Base

  belongs_to :employee

  validates :employee, presence: true

  scope :in_month_range, ->(time) { where('entrances.clocked_at' => @month_range) }
end
