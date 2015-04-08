module NewRelic
  module Shoes
    class Reporter
      HEADER = ["Call", "Count", "Total Time (s)", "Excl. Time (s)", "IPS"]
      def report(io=STDOUT)
        metrics = NewRelic::Agent.instance.stats_engine.harvest!
        results = [HEADER]

        append_to_results(metrics, results)
        max_width = max_width_from(results)
        print_results(io, results, max_width)
      end

      def append_to_results(metrics, results)
        results.concat(metrics.map do |spec, stats|
          [
            spec.name,
            stats.call_count.to_s,
            stats.total_call_time.round(6).to_s,
            stats.total_exclusive_time.round(6).to_s,
            ips_from_stats(stats).round.to_s
          ]
        end)
      end

      def ips_from_stats(stats)
        if stats.total_call_time > 0 && stats.call_count > 0
          (1.0/(stats.total_call_time/stats.call_count))
        else
          0.0
        end
      end

      def max_width_from(results)
        results.inject([]) do |memo, row|
          row.each_with_index do |column, index|
            if memo[index].nil? || memo[index] < column.length
              memo[index] = column.length
            end
          end
          memo
        end
      end

      def print_results(io, results, max_width)
        results.each do |row|
          row.each_with_index do |column, index|
            io.print column
            io.print " " * (max_width[index] - column.length + 2)
          end
          io.print "\n"
        end
      end
    end
  end
end
