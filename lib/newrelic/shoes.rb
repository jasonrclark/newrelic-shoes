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
    metrics = NewRelic::Agent.instance.stats_engine.harvest!
    results = [["Call", "Count", "Total Time (s)", "Excl. Time (s)", "IPS"]]
    metrics.each do |spec, stats|
      if stats.total_call_time > 0 && stats.call_count > 0
        ips = (1.0/(stats.total_call_time/stats.call_count))
      else
        ips = 0.0
      end

      results << [
        spec.name,
        stats.call_count.to_s,
        stats.total_call_time.round(6).to_s,
        stats.total_exclusive_time.round(6).to_s,
        ips.round.to_s
      ]
    end

    max_width = results.inject([]) do |memo, row|
      row.each_with_index do |column, index|
        if memo[index].nil? || memo[index] < column.length
          memo[index] = column.length
        end
      end
      memo
    end

    results.each do |row|
      row.each_with_index do |column, index|
        print column
        print " " * (max_width[index] - column.length + 2)
      end
      print "\n"
    end
  end
end
