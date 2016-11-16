// This manifest builds all the files used by the room layout.
// cable.coffee includes ActionCable itself, and does a require_tree on channels, so we don't need to include that here.
// If there were other room specific JS (like OT, TJS, etc. we would load that here too.
//= require 'cable'
