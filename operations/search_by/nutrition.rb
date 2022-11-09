# frozen_string_literal: true

require_relative '../base_operation'
require 'telegram/bot'

Dir['./models/*.rb'].each { |file| require_relative "../../#{file}" }
Dir['./services/*.rb'].each { |file| require_relative "../../#{file}" }

module Operations
  module SearchBy
    class Nutrition < Operations::BaseOperation
      def perform
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: 'Enter the name of what you are looking for. Example (100 gram butter, 1 cup coffee):'
        )
        @bot.listen do |message|
          return handle_message(message: message)
        end
      end

      private

      def success(answer:)
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: answer
        )
      end

      def handle_message(message:)
        answer = NutritionAnalysis.nutrition_data(ingredient: message)

        return success(answer: answer) unless answer == nil

        error(errors: { errors: ['Found nothing...'] })
      end
    end
  end
end