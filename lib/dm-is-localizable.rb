# Require plugin-files
dir = Pathname(__FILE__).dirname.expand_path / 'dm-is-localizable'
require dir / 'is' / 'localizable'
require dir / 'storage' / 'language'
require dir / 'storage' / 'translation'

# Include the plugin in Model
DataMapper::Model.append_extensions DataMapper::Is::Localizable