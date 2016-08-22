module API
  module Integrations
    SUPPORTED_INTEGRATIONS = {
      :all_typeforms => {
        :endpoint => 'https://api.typeform.com/v1/forms',
        :requirements => [:key],
        :format => [:endpoint,'?key=',:key]
      },
      :typeform => {
        :endpoint => 'https://api.typeform.com/v1/form',
        :requirements => [:typeform_UID, :key],
        :optional => [:order_by, :completed, :offset, :limit],
        :format => [:endpoint,'/',:typeform_UID,'?key=',:key,'&order_by=',:order_by,'&offset=',:offset,'&limit=',:limit,'&completed=',:completed]
      },
      :test => {
        :endpoint => "",
        :requirements => [:api_token],
        :optional => [:sort_by],
        :format => ["http://google.com"],
      },
      :test_builder => {
        :endpoint => "http://tester.iox/",
        :requirements => [:api_token],
        :optional => [:sort_by],
        :format => [:endpoint, :api_token, "?=", :sort_by],
      }
    }
  end
end
