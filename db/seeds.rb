require 'json'
require 'open-uri'

puts 'Cleaning database...'
Cocktail.destroy_all
Ingredient.destroy_all
Dose.destroy_all

#SEED COCKTAILS (NAME & PHOTO)
puts 'Creating COCKTAILS (NAME & PHOTO)...'

url = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'
file = open(url).read
cocktail_list = JSON.parse(file)

array_cocktails = cocktail_list.values.flatten

array_cocktails.each do |cocktail|
  Cocktail.create!(name: cocktail.values.first, photo: cocktail.values.second)
  p Cocktail.last.name
  p Cocktail.last.photo

  # FIND COCKTAILS BY ID
  url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{cocktail.values.third}"
  # puts url
  # url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=13060"
  file = open(url).read
  cocktail_details = JSON.parse(file)

  array_details = cocktail_details.values.flatten

  array_details.each do |detail|

    # SEED INGREDIENTS
    cocktail_ingredients = detail.values.last(31).first(15)
    # p cocktail_ingredients

    cocktail_ingredients.each_index do |i|
      cocktail_ingredients[i] = "" if cocktail_ingredients[i].nil?
    end

    cocktail_doses = detail.values.last(16).first(15)
    # p cocktail_doses

    cocktail_doses.each_index do |i|
      cocktail_doses[i] = "" if cocktail_doses[i].nil?
    end

    for index in 0...14
      if cocktail_ingredients[index] != ''
        ingredient = cocktail_ingredients[index]
        p ingredient
        Ingredient.create!(name: ingredient)
        # SEED DOSES
        dose = cocktail_doses[index]
        p dose
        # Dose.create!(description: dose, ingredient_id: Ingredient.where(name: ingredient), cocktail_id: Cocktail.where(name: Cocktail.last.name))
        # Dose.create(description: dose, ingredient_id: Ingredient.where(id: Ingredient.last.id), cocktail_id: Cocktail.where(name: Cocktail.last.name))
        Dose.create(description: dose, ingredient: Ingredient.last, cocktail: Cocktail.last)

      end
    end
  end
end
