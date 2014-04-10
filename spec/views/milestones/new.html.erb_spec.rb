require 'spec_helper'

describe "milestones/new" do
  before(:each) do
    assign(:milestone, stub_model(Milestone,
      :references => "",
      :references => "",
      :kind => "MyString",
      :details => "MyText",
      :size => "MyString"
    ).as_new_record)
  end

  it "renders new milestone form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", milestones_path, "post" do
      assert_select "input#milestone_references[name=?]", "milestone[references]"
      assert_select "input#milestone_references[name=?]", "milestone[references]"
      assert_select "input#milestone_kind[name=?]", "milestone[kind]"
      assert_select "textarea#milestone_details[name=?]", "milestone[details]"
      assert_select "input#milestone_size[name=?]", "milestone[size]"
    end
  end
end
