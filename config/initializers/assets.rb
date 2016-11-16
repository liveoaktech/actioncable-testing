# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# These files need to be built explicitly because room-related JS is loaded separately.
# cable.coffee includes ActionCable itself, and does a require_tree on channels, so we don't need to include that here.
Rails.application.config.assets.precompile += %w( cable.js )
Rails.application.config.assets.precompile += %w( rooms.js )
