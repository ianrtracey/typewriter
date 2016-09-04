require_relative '../../models/form'

describe Form do
  it "can be persisted to the database" do
    form = Form.new("test", "foobar", {:form => {}, :states => [], :actions => []})
    result = form.save
    expect(result.n).to eq(1)
  end
  it "can find documents based on params" do
    forms = Form.find("foobar", {form_id: "test"})
    form = forms.first
    expect(form[:form_id]).to eq("test")
    expect(form[:user_id]).to eq("foobar")
    expect(form[:form]).to eq({})
    expect(form[:states]).to eq([])
    expect(form[:actions]).to eq([])
  end

  it "can update fields based on params" do
    forms = Form.find("foobar", {form_id: "test"})
    form = forms.first
    result = form.update(:states => ["a","b","c"])
    expect(result.n).to eq(1)
  end
end
