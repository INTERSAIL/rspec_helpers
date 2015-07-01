require 'rails_helper'

module Helpers
  module Request
    module Api
      def parseResponse
        @json ||= JSON(response.body, symbolize_names: true)
      end
    end
  end
end
