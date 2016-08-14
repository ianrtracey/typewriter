require_relative '../../api/APIConnection'
require_relative '../../api/api'
require 'pry'

describe "Typeform connection" do
  it "can establish a 200 OK connection with Typeform API" do
    typeform_api = APIConnection.new(:typeform,
                                       :typeform_UID => 'C7QX2g',
                                       :key => ENV['TYPEFORM_KEY'],
                                      )
    response = typeform_api.connection.get
    expect(response.status).to eql(200)
  end
end

describe "Typeform API" do
  it "can get form data" do
    result = API::Typeform.get_form('C7QX2g')
    result.form
    expect(result.contents).to_not be_nil
  end
end
