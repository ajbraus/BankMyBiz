require 'spec_helper'

describe "answers/new" do
  before(:each) do
    assign(:answer, stub_model(Answer,
      :body => "MyText",
      :user => nil,
      :post => nil,
      :accepted => false
    ).as_new_record)
  end

  it "renders new answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", answers_path, "post" do
      assert_select "textarea#answer_body[name=?]", "answer[body]"
      assert_select "input#answer_user[name=?]", "answer[user]"
      assert_select "input#answer_post[name=?]", "answer[post]"
      assert_select "input#answer_accepted[name=?]", "answer[accepted]"
    end
  end
end
