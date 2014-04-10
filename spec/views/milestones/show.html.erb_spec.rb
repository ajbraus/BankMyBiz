require 'spec_helper'

describe "milestones/show" do
  before(:each) do
    @milestone = assign(:milestone, stub_model(Milestone,
      :references => "",
      :references => "",
      :kind => "Kind",
      :details => "MyText",
      :size => "Size"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Kind/)
    rendered.should match(/MyText/)
    rendered.should match(/Size/)
  end
end
