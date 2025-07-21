require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'

  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Controllers', 'app/controllers'

  minimum_coverage 90
end
