require_relative './integrations'
require_relative './APIConnection'
require_relative '../responses/typeform_response'
require 'json'

module API
include API::Integrations

  module DummyAPI
    def self.test_api_method(sort_by_val)
      test_connection = APIConnection.new(:test,
                                          :api_token => "test",
                                          :sort_by => sort_by_val
                                    )
      response = test_connection.connection.get
      return response.status
    end
  end

  module Typeform

    def self.get_forms(key=ENV['TYPEFORM_KEY'])
      typeform_connection = APIConnection.new(:all_typeforms,
                                              :key => key
                                             )
      response = typeform_connection.connection.get
      parsed_response = JSON.parse(response.body, {:symbolize_names => true })
      return parsed_response


    end

    def self.get_form(form_id, offset=1, key=ENV['TYPEFORM_KEY'])
      typeform_connection = APIConnection.new(:typeform,
                                              :typeform_UID => form_id,
                                              :key => key,
                                              :order_by => 'date_submit',
                                              :offset => offset.to_s,
                                              :limit => '1000',
                                              :completed => 'true'
                                             )
      response = typeform_connection.connection.get
      parsed_response = JSON.parse(response.body, {:symbolize_names => true })
      return TypeformResponse.new(parsed_response, :offset => offset)
    end
  end
end
