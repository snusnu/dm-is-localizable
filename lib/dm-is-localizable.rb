require 'dm-is-localizable/is/localizable'
require 'dm-is-localizable/storage/language'

# Include the plugin in Model
DataMapper::Model.append_extensions DataMapper::Is::Localizable
