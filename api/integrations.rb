module API
  module Integrations
    SUPPORTED_INTEGRATIONS = {
      :typeform => {
        :endpoint => 'https://api.typeform.com/v1/form',
        :requirements => [:typeform_UID],
        :optional => [:key],
        :format => [:endpoint,'/',:typeform_UID,'?key=',:key]
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
