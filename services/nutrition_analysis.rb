require 'faraday'

class NutritionAnalysis
  class << self

    def nutrition_data(ingredient:)
      responce = self.send_request(ingr: ingredient.text.gsub(' ', '%20').gsub(',', '%2C'))

      return self.parse(responce: JSON.parse(responce.body))
    end

    private

    def send_request(ingr:)
      Faraday.get(
        "https://api.edamam.com/api/nutrition-data?app_id=#{ENV.fetch('NUTRITION_ANALYSIS_API_ID')}&app_key=#{ENV.fetch('NUTRITION_ANALYSIS_API_KEY')}&nutrition-type=cooking&ingr=#{ingr}"
      )
    end

    def parse(responce:)
      result = "### Info ###\n"

      responce['totalNutrients'].each do |element|
        element.second.each_value do |val|
          result += (' ' + val.to_s + ',')
        end

        result += "\n"
      end

      result += "\n### Daily norm ###\n"
      responce['totalDaily'].each do |element|

        element.second.each_value do |val|
          result += (' ' + val.to_s)
        end

        result += "\n"
      end

      return result
    end
  end
end