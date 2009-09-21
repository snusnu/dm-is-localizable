require 'dm-is-localizable/is/localizable'
require 'dm-is-localizable/storage/language'
require 'dm-is-localizable/storage/translation'

# Include the plugin in Model
DataMapper::Model.append_extensions DataMapper::Is::Localizable
