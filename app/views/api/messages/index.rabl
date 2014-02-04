object false
 
child @messages => :messages do
  extends "api/messages/show"
end
 
child @sent_messages => :sent_messages do
  extends "api/messages/show"
end