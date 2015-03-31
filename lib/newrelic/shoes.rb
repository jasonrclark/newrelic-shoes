require "newrelic/shoes/version"

Shoes::InternalApp.add_global_keypress(:'control_alt_n') do
  puts "Loading New Relic for Shoes!"

  require "new_relic/agent"
  require "new_relic/agent/method_tracer"

  NewRelic::Agent.manual_start(monitor_mode: false, developer: true)

  class Shoes::Swt::Common::Painter
    include NewRelic::Agent::MethodTracer
    add_method_tracer :paint_control, 'Shoes/#{self.class.name}/paint_control'
  end

  class Shoes::Swt::TextBlock::Painter
    include NewRelic::Agent::MethodTracer
    add_method_tracer :paintControl, 'Shoes/#{self.class.name}/paint_control'
  end

  at_exit do
    puts "\nCall\tCount\tTotal Time"
    metrics = NewRelic::Agent.instance.stats_engine.harvest!
    metrics.each do |spec, stats|
      puts "#{spec.name}\t#{stats.call_count}\t#{stats.total_call_time}\t#{1.0/(stats.total_call_time/stats.call_count)}"
    end
  end
end
