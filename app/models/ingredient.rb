class Ingredient < ApplicationRecord
  attr_accessor :dose_id
  validates :name, presence: true
  has_many :doses

  accepts_nested_attributes_for :doses
end
