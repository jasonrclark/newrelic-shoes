require "new_relic/agent"
require "new_relic/agent/method_tracer"

module NewRelic
  module Shoes
    module Instrumentation
      def self.install
        NewRelic::Agent.manual_start(monitor_mode: false, developer: true)

        trace(::Shoes::Swt::Common::Painter, :paint_control)
        trace(::Shoes::Swt::Common::Painter, :paint_object)
        trace(::Shoes::Swt::Common::Painter, :fill_setup)
        trace(::Shoes::Swt::Common::Painter, :draw_setup)
        trace(::Shoes::Swt::Common::Painter, :set_rotate)

        trace(::Shoes::Swt::RectPainter, :fill)
        trace(::Shoes::Swt::RectPainter, :draw)

        trace(::Shoes::Swt::TextBlock::Painter, :paintControl)
        trace(::Shoes::Swt::TextBlock::Painter, :draw_layouts)

        trace(::Shoes::Swt::ColorFactory, :create)
        trace(::Shoes::Swt::ColorFactory, :create_new)
      end

      def self.trace(clazz, method_name, metric_suffix=method_name)
        clazz.class_eval do
          include NewRelic::Agent::MethodTracer
          add_method_tracer method_name, 'Shoes/#{self.class.name}/' + metric_suffix.to_s
        end
      end
    end
  end
end
