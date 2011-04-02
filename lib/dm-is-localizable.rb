require 'dm-core'
require 'dm-validations'
require 'dm-is-remixable'
require 'dm-accepts_nested_attributes'

require 'dm-is-localizable/backend'
require 'dm-is-localizable/locale'
require 'dm-is-localizable/model'
require 'dm-is-localizable/resource'

DataMapper::Model.append_extensions DataMapper::I18n::Model
