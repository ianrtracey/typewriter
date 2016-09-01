require_relative '../../models/form'

describe Form do
  it "can be persisted to the database" do
    form = Form.new("test", "foobar", {:form => {}, :states => [], :actions => []})
    result = form.save
    expect(result.n).to eq(1)
  end
end
