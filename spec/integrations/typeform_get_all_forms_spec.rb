require_relative '../../api/api'

describe "Typeform get_forms()" do

  it "can return a list of forms" do
    response = API::Typeform.get_forms
    binding.pry
    expect(response).to_not be_nil
  end
end
