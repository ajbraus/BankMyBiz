require 'spec_helper'

describe "answers/show" do
  before(:each) do
    @answer = assign(:answer, stub_model(Answer,
      :body => "MyText",
      :user => nil,
      :post => nil,
      :accepted => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/false/)
  end
end
