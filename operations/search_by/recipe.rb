# frozen_string_literal: true

require_relative '../base_operation'
require 'telegram/bot'

Dir['./models/*.rb'].each { |file| require_relative "../../#{file}" }
Dir['./services/*.rb'].each { |file| require_relative "../../#{file}" }

module Operations
  module SearchBy
    class Recipe < Operations::BaseOperation
      def perform
        handle_message(message: @message.data.split.last)
      end

      private

      def success(answer:)
        @bot.api.sendPhoto(
          chat_id: @message.from.id,
          photo: answer['strDrinkThumb']
        )
        @bot.api.send_message(
          chat_id: @message.from.id,
          text: Services::TextHandlerCocktail.new.text_for_message(answer: answer)
        )
      end

      def handle_message(message:)
        success(answer: RecipeSearch.nutrition_data(ingredient: message))

        # error(errors: { errors: ['Found nothing...'] })
      end
    end
  end
end