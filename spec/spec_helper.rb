require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'active_record'
require 'mongoid'

if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'simple_enum'
require 'simple_enum/persistence'

require 'support/active_record_support'
require 'support/i18n_support'
require 'support/model_support'
require 'support/mongoid_support'

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.include ModelSupport
  config.include I18nSupport, i18n: true
  config.include ActiveRecordSupport, active_record: true
  config.include MongoidSupport, mongoid: true
end
