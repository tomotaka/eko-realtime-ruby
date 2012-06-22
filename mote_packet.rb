# coding: utf-8

require "rubygems"
require "nokogiri"

class MotePacket

  class Internal
    attr_accessor :node_id, :health_neighbor_ids
  end

  attr_accessor :packet_name, :node_id, :port, :values, :value_types, :internal

  def self.parse(str_xml)
    doc = Nokogiri::XML(str_xml)

    ret = self.new
    ret.packet_name = doc.xpath("//MotePacket/PacketName/text()").text
    ret.node_id = doc.xpath("//MotePacket/NodeId/text()").text
    ret.port = doc.xpath("//MotePacket/Port/text()").text
    
    values = {}
    value_types = {}
    parsed_data_element_nodes = doc.xpath("//MotePacket/ParsedDataElement")
    parsed_data_element_nodes.each do |pde_node|
      name = pde_node.xpath("./Name/text()").text
      value = pde_node.xpath("./ConvertedValue/text()").text
      v_type = pde_node.xpath("./ConvertedValueType/text()").text
      if v_type =~ /uint/ then
        value = value.to_i
      elsif v_type =~ /float/ then
        value = value.to_f
      end
      values[name] = value
      value_types[name] = v_type
    end
    ret.values = values
    ret.value_types = value_types

    internal = Internal.new
    internal.node_id = doc.xpath("//MotePacket/internal/nodeId/text()").text
    health_neighbor_ids = doc.xpath("//MotePacket/internal/healthNeighborIds/text()").text
    internal.health_neighbor_ids = health_neighbor_ids.split(/\s+/).select{|x| x =~ /\d+/ }.map{|x| x.to_i }
    ret.internal = internal

    return ret
  end

end
