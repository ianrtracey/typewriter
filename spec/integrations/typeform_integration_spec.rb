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
    expect(result.contents).to_not be_nil
    expect(result.questions).to_not be_nil
    expect(result.answers).to_not be_nil
    expect(result.form).to_not be_nil
  end

  it "contains an offset result value in order to support pagination" do
    result = API::Typeform.get_form('C7QX2g')
    expect(result.offset).to eql(1)
    result = API::Typeform.get_form('C7QX2g', 2)
    expect(result.offset).to eql(2)
  end

  it "paginates data and can get the next series" do
    result = API::Typeform.get_form('C7QX2g')
    expect(result.has_more?).to be_truthy
    result = API::Typeform.get_form('C7QX2g', 2)
    expect(result.has_more?).to be_falsy
  end
end
