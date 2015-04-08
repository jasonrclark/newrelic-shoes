require "newrelic/shoes/version"
require "newrelic/shoes/instrumentation"
require "newrelic/shoes/reporter"

puts "New Relic for Shoes is available. Press Ctrl+Alt+N to start tracing.\n\n"

Shoes::InternalApp.add_global_keypress(:'control_alt_n') do

  puts "Tracing with New Relic for Shoes! Your metrics will output at exit.\n\n"
  NewRelic::Shoes::Instrumentation.install

  at_exit do
    NewRelic::Shoes::Reporter.new.report
  end
end
