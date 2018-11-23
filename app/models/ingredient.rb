class Ingredient < ApplicationRecord
  attr_accessor :dose_id
  validates :name, presence: true, uniqueness: true
  has_many :doses

end
