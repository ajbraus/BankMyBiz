collection @messages, :root => "received_messages"
extends "api/messages/show"

collection @sent_messages, :root => "sent_messages"
extends "api/messages/show"