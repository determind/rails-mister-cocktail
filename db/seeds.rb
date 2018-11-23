# require 'json'
# require 'open-uri'

# puts 'Cleaning database...'
# Cocktail.destroy_all
# Ingredient.destroy_all
# Dose.destroy_all

# #SEED COCKTAILS (NAME & PHOTO)
# puts 'Creating COCKTAILS (NAME & PHOTO)...'

# url = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'
# file = open(url).read
# cocktail_list = JSON.parse(file)

# array_cocktails = cocktail_list.values.flatten

# array_cocktails.each do |cocktail|
#   Cocktail.create!(name: cocktail.values.first, photo: cocktail.values.second)
#   p Cocktail.last.name
#   p Cocktail.last.photo

#   # FIND COCKTAILS BY ID
#   url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{cocktail.values.third}"
#   # puts url
#   # url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=13060"
#   file = open(url).read
#   cocktail_details = JSON.parse(file)

#   array_details = cocktail_details.values.flatten

#   array_details.each do |detail|

#     # SEED INGREDIENTS
#     cocktail_ingredients = detail.values.last(31).first(15)
#     # p cocktail_ingredients

#     cocktail_ingredients.each_index do |i|
#       cocktail_ingredients[i] = "" if cocktail_ingredients[i].nil?
#     end

#     cocktail_doses = detail.values.last(16).first(15)
#     # p cocktail_doses

#     cocktail_doses.each_index do |i|
#       cocktail_doses[i] = "" if cocktail_doses[i].nil?
#     end

#     for index in 0...14
#       if cocktail_ingredients[index] != ''
#         ingredient = cocktail_ingredients[index].squish
#         p ingredient
#         Ingredient.create!(name: ingredient)
#         # SEED DOSES
#         if cocktail_doses[index].squish != ''
#         dose = cocktail_doses[index].squish
#         p dose
#         # Dose.create!(description: dose, ingredient_id: Ingredient.where(name: ingredient), cocktail_id: Cocktail.where(name: Cocktail.last.name))
#         # Dose.create(description: dose, ingredient_id: Ingredient.where(id: Ingredient.last.id), cocktail_id: Cocktail.where(name: Cocktail.last.name))
#         Dose.create(description: dose, ingredient: Ingredient.last, cocktail: Cocktail.last)
#         end
#       end
#     end
#   end
# end

puts 'DB Destroy ----------'
Dose.destroy_all
Cocktail.destroy_all
Ingredient.destroy_all
puts 'Done!'


puts 'Creating Ingredients...'

url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
user_serialized = open(url).read
result = JSON.parse(user_serialized)
  result['drinks'].each do |item|
    Ingredient.create!(name: item["strIngredient1"])
    # p item['strIngredient1']
  end

puts 'Done!!'
puts 'Creating Cocktails & Doses...'

  cocktails_url = Array.new
  url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail"
  user_serialized = open(url).read
  result = JSON.parse(user_serialized)
    result['drinks'].each do |item|
      cocktail_url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{item["idDrink"]}"
      cocktails_url << cocktail_url
    end

  cocktails_url.each do |url|
    cocktail_ingredients = []
    user_serialized = open(url).read
    result = JSON.parse(user_serialized)
      cocktail = Cocktail.new(name: result['drinks'][0]['strDrink'])
      cocktail.description = result['drinks'][0]['strInstructions']
      cocktail.image_url = result['drinks'][0]["strDrinkThumb"]
      result['drinks'][0].each do |item|
        if (/strIngredient/).match?(item[0])
          cocktail_ingredients << item[1]
        end
      end

    cocktail_ingredients.reject!(&:blank?).each do |ingredient|
      if Ingredient.where(name: ingredient).count == 1
        i = cocktail_ingredients.find_index(ingredient)
        dose = Dose.new(description: result['drinks'][0]["strMeasure#{i+1}"])
        dose.ingredient_id = Ingredient.where(name: ingredient).first.id
        dose.cocktail = cocktail
        dose.save
      else
        new_ingredient = Ingredient.create!(name: ingredient)
        i = cocktail_ingredients.find_index(ingredient)
        dose = Dose.new(description: result['drinks'][0]["strMeasure#{i+1}"])
        dose.ingredient_id = Ingredient.where(name: ingredient).first.id
        dose.cocktail = cocktail
        dose.save
      end
    end
  end

puts 'Done!!!'
