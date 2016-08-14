require_relative '../../api/APIConnection'

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
