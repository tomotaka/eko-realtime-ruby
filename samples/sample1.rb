#!/usr/bin/ruby
# coding: utf-8

require File.expand_path("../eko_realtime.rb", File.dirname(__FILE__))

class MyEkoEventListener < EkoEventListener
  def eko_sensor_event(mote_packet)
    puts "----- got MotePacket ----"
    puts "PacketName:#{mote_packet.packet_name}"
    puts "NodeId=#{mote_packet.node_id}"
    puts "Port=#{mote_packet.port}"
    puts "Internal.NodeId=#{mote_packet.internal.node_id}"
    puts "Internal.HealthNeighborIds=#{mote_packet.internal.health_neighbor_ids}"
    puts "Values:"
    mote_packet.values.each do |k, v|
      #puts "  #{k}: #{v}          (type=#{mote_packet.value_types[k]})"
      puts sprintf("% 30s: %s", "#{k}(type=#{mote_packet.value_types[k]})", v)
    end
    puts ""
  end
end

eko_realtime = EkoRealtime.new("eko-gateway.ht.sfc.keio.ac.jp", 9005)
eko_realtime.add_listener(MyEkoEventListener.new)
eko_realtime.run



