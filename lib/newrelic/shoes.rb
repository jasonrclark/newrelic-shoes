require "newrelic/shoes/version"

puts "New Relic for Shoes is available. Press Ctrl+Alt+N to start tracing.\n\n"

Shoes::InternalApp.add_global_keypress(:'control_alt_n') do
  puts "Tracing with New Relic for Shoes! Your metrics will output at exit.\n\n"

  require "new_relic/agent"
  require "new_relic/agent/method_tracer"

  NewRelic::Agent.manual_start(monitor_mode: false, developer: true)

  class Shoes::Swt::Common::Painter
    include NewRelic::Agent::MethodTracer

    add_method_tracer :paint_control, 'Shoes/#{self.class.name}/paint_control'
    add_method_tracer :paint_object,  'Shoes/#{self.class.name}/paint_object'

    add_method_tracer :fill_setup, 'Shoes/#{self.class.name}/fill_setup'
    add_method_tracer :draw_setup, 'Shoes/#{self.class.name}/draw_setup'
    add_method_tracer :set_rotate, 'Shoes/#{self.class.name}/set_rotate'
  end

  class Shoes::Swt::RectPainter
    include NewRelic::Agent::MethodTracer

    add_method_tracer :fill, 'Shoes/#{self.class.name}/fill'
    add_method_tracer :draw, 'Shoes/#{self.class.name}/draw'
  end

  class Shoes::Swt::TextBlock::Painter
    include NewRelic::Agent::MethodTracer

    add_method_tracer :paintControl, 'Shoes/#{self.class.name}/paint_control'
    add_method_tracer :draw_layouts, 'Shoes/#{self.class.name}/draw_layouts'
  end

  class Shoes::Swt::ColorFactory
    include NewRelic::Agent::MethodTracer

    add_method_tracer :create, 'Shoes/#{self.class.name}/create'
    add_method_tracer :create_new, 'Shoes/#{self.class.name}/create_new'
  end

  at_exit do
    puts "\nCall\tCount\tTotal Time"
    metrics = NewRelic::Agent.instance.stats_engine.harvest!
    metrics.each do |spec, stats|
      puts "#{spec.name}\t#{stats.call_count}\t#{stats.total_call_time}\t#{1.0/(stats.total_call_time/stats.call_count)}"
    end
  end
end
