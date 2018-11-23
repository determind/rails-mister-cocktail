class Dose < ApplicationRecord
  # attr_accessor :ingredient_id
  belongs_to :ingredient
  belongs_to :cocktail
  validates :description, presence: true
  validates :ingredient, presence: true
  validates :cocktail, uniqueness: { scope: :ingredient }
  # accepts_nested_attributes_for :ingredient
end
