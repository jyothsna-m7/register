# frozen_string_literal: true
module EventHelper
  def clock_in_pretty(event)
    event.clock_in&.strftime('%d %b %y at %H:%M')
  end

  def clock_out_pretty(event)
    event.clock_out&.strftime('%d %b %y at %H:%M')
  end
end