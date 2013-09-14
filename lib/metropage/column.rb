#!/usr/bin/env ruby
# encoding: UTF-8

# Columns act like column vectors for tiles
class MetroPage::Column
  attr_accessor :name, :tiles
  
  # Create a column
  def initialize(name:"", tiles:[])
    @name = name
    @tiles = tiles
  end
  # Push a tile into the column
  def push(*args)
    @tiles.push *args
    return self
  end
end
