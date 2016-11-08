# Action Cable provides the framework to deal with WebSockets in Rails.
# You can generate new channels where WebSocket features live using the rails generate channel command.
#
# Turn on the cable connection by removing the comments after the require statements (and ensure it's also on in config/routes.rb).
#
#= require action_cable
#= require_self
#= require_tree ./channels
#
# Every example app calls createConsumer with no arguments. However, doing that always fails - possibly it works in
# http but not in https. With HTTPS, browsers get the following error in console:
#     WebSocket connection to 'ws://localhost:3000/cable' failed: Connection closed before receiving a handshake response
 @App ||= {}
 App.cable = ActionCable.createConsumer("/cable")
