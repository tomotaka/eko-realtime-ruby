#!/usr/bin/ruby
# coding: utf-8

require "socket"

require File.expand_path("./mote_packet.rb", File.dirname(__FILE__))

class EkoEventListener
  def eko_sensor_event(mote_packet)
    raise "you should override this method"
  end
end

class EkoRealtime
  
  attr_accessor :host, :port

  attr_reader :is_stopped, :listeners

  # maybe parameter 'host' will be 'eko-gateway.ht.sfc.keio.ac.jp'
  def initialize(host, port=9005)
    @host = host
    @port = port
    @is_stopped = false
    @listeners = []
  end

  # expecting parameter 'listener' has a method 'eko_sensor_event' like EkoEventListener
  def add_listener(listener)
    @listeners << listener
  end

  def run
    sock = TCPSocket.new(@host, @port)
    begin
      while not @is_stopped do
        length_bin = sock.read(4)
        length = length_bin.unpack("I").first
        str_xml = sock.read(length)
        deliver_event(MotePacket.parse(str_xml))
      end
    ensure
      sock.close
    end
  end

  # you can stop running from other thread
  def stop
    @is_stopped = truek
  end

  private

  def deliver_event(mote_packet)
    @listeners.each do |listener|
      listener.eko_sensor_event(mote_packet)
    end
  end

end
