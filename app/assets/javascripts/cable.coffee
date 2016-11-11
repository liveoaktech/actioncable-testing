# Action Cable provides the framework to deal with WebSockets in Rails.
# You can generate new channels where WebSocket features live using the rails generate channel command.
#
# Turn on the cable connection by removing the comments after the require statements (and ensure it's also on in config/routes.rb).
#
#= require action_cable
#= require_self
#= require_tree ./channels
#
# This works with createConsumer() left to the default if both develop.rb and production.rb specificy config.action_cable.url
 @App ||= {}
 App.cable = ActionCable.createConsumer()
