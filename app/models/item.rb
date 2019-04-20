class Item < ApplicationRecord
  belongs_to :partner_request, optional: true
  #validates :name, :quantity, presence: true, allow_blank: false
  validates :name, inclusion: { in: POSSIBLE_ITEMS.keys }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_blank: false
end
