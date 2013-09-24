# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130924173334) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "ages", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ages_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "age_id"
  end

  add_index "ages_users", ["age_id", "user_id"], :name => "index_ages_users_on_age_id_and_user_id"
  add_index "ages_users", ["user_id", "age_id"], :name => "index_ages_users_on_user_id_and_age_id"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authentications", ["uid"], :name => "index_authentications_on_uid"
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "business_types", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "business_types_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "business_type_id"
  end

  add_index "business_types_users", ["business_type_id", "user_id"], :name => "index_business_types_users_on_business_type_id_and_user_id"
  add_index "business_types_users", ["user_id", "business_type_id"], :name => "index_business_types_users_on_user_id_and_business_type_id"

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"

  create_table "commitments", :force => true do |t|
    t.integer  "committed_user_id"
    t.integer  "commitment_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "commitments", ["commitment_id"], :name => "index_commitments_on_commitment_id"
  add_index "commitments", ["committed_user_id", "commitment_id"], :name => "index_commitments_on_committed_user_id_and_commitment_id", :unique => true
  add_index "commitments", ["committed_user_id"], :name => "index_commitments_on_committed_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "employee_sizes", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "employee_sizes_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "employee_size_id"
  end

  add_index "employee_sizes_users", ["employee_size_id", "user_id"], :name => "index_employee_sizes_users_on_employee_size_id_and_user_id"
  add_index "employee_sizes_users", ["user_id", "employee_size_id"], :name => "index_employee_sizes_users_on_user_id_and_employee_size_id"

  create_table "impressions", :force => true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], :name => "controlleraction_ip_index"
  add_index "impressions", ["controller_name", "action_name", "request_hash"], :name => "controlleraction_request_index"
  add_index "impressions", ["controller_name", "action_name", "session_hash"], :name => "controlleraction_session_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], :name => "poly_ip_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], :name => "poly_request_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], :name => "poly_session_index"
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], :name => "impressionable_type_message_index"
  add_index "impressions", ["user_id"], :name => "index_impressions_on_user_id"

  create_table "industries", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "industries_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "industry_id"
  end

  add_index "industries_users", ["industry_id", "user_id"], :name => "index_industries_users_on_industry_id_and_user_id"
  add_index "industries_users", ["user_id", "industry_id"], :name => "index_industries_users_on_user_id_and_industry_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "location_id"
  end

  add_index "locations_users", ["location_id", "user_id"], :name => "index_locations_users_on_location_id_and_user_id"
  add_index "locations_users", ["user_id", "location_id"], :name => "index_locations_users_on_user_id_and_location_id"

  create_table "matches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "match_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "matches", ["match_id"], :name => "index_matches_on_match_id"
  add_index "matches", ["user_id", "match_id"], :name => "index_matches_on_user_id_and_match_id", :unique => true
  add_index "matches", ["user_id"], :name => "index_matches_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.boolean  "is_read"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "peers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "peer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "peers", ["peer_id"], :name => "index_peers_on_peer_id"
  add_index "peers", ["user_id", "peer_id"], :name => "index_peers_on_user_id_and_peer_id", :unique => true
  add_index "peers", ["user_id"], :name => "index_peers_on_user_id"

  create_table "posts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.boolean  "bank"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  add_index "posts_tags", ["post_id", "tag_id"], :name => "index_posts_tags_on_post_id_and_tag_id"
  add_index "posts_tags", ["tag_id", "post_id"], :name => "index_posts_tags_on_tag_id_and_post_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "revenue_sizes", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "revenue_sizes_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "revenue_size_id"
  end

  add_index "revenue_sizes_users", ["revenue_size_id", "user_id"], :name => "index_revenue_sizes_users_on_revenue_size_id_and_user_id"
  add_index "revenue_sizes_users", ["user_id", "revenue_size_id"], :name => "index_revenue_sizes_users_on_user_id_and_revenue_size_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.string   "stripe_customer_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "expires_on"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "name",                   :default => "",    :null => false
    t.text     "bio",                    :default => "",    :null => false
    t.boolean  "bank"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "impressions_count",      :default => 0
    t.string   "pic_url"
    t.string   "linked_in_url"
    t.string   "location"
    t.boolean  "terms",                  :default => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "admin",                  :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "rejected_at"
    t.boolean  "deleted",                :default => false
    t.string   "org_name"
    t.string   "position"
    t.text     "goals"
    t.boolean  "newsletter",             :default => true
    t.string   "username"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false, :null => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
