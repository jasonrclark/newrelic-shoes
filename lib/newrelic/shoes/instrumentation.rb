require "new_relic/agent"
require "new_relic/agent/method_tracer"

module NewRelic
  module Shoes
    module Instrumentation
      def self.install
        NewRelic::Agent.manual_start(monitor_mode: false, developer: true)

        ::Shoes::Swt::Common::Painter.class_eval do
          include NewRelic::Agent::MethodTracer

          add_method_tracer :paint_control, 'Shoes/#{self.class.name}/paint_control'
          add_method_tracer :paint_object,  'Shoes/#{self.class.name}/paint_object'

          add_method_tracer :fill_setup, 'Shoes/#{self.class.name}/fill_setup'
          add_method_tracer :draw_setup, 'Shoes/#{self.class.name}/draw_setup'
          add_method_tracer :set_rotate, 'Shoes/#{self.class.name}/set_rotate'
        end

        ::Shoes::Swt::RectPainter.class_eval do
          include NewRelic::Agent::MethodTracer

          add_method_tracer :fill, 'Shoes/#{self.class.name}/fill'
          add_method_tracer :draw, 'Shoes/#{self.class.name}/draw'
        end

        ::Shoes::Swt::TextBlock::Painter.class_eval do
          include NewRelic::Agent::MethodTracer

          add_method_tracer :paintControl, 'Shoes/#{self.class.name}/paint_control'
          add_method_tracer :draw_layouts, 'Shoes/#{self.class.name}/draw_layouts'
        end

        ::Shoes::Swt::ColorFactory.class_eval do
          include NewRelic::Agent::MethodTracer

          add_method_tracer :create, 'Shoes/#{self.class.name}/create'
          add_method_tracer :create_new, 'Shoes/#{self.class.name}/create_new'
        end
      end
    end
  end
end
