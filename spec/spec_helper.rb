require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  if ENV['PARSER'] == 'future'
    c.parser = 'future'
  end
end
