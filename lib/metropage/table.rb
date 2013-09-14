#!/usr/bin/env ruby
# encoding: UTF-8

# Tables contains columns
# @note Recommanded upper limit: 4 columns
class MetroPage::Table
  attr_accessor :name, :columns

  # Create a table
  def initialize(name:"", columns:[])
    @name = name
    @columns = columns
  end
  # Push a column into the table
  def push(*args)
    @columns.push *args
    return self
  end
  # @private
  def to_s(lang)
    REXML::Formatters::Pretty.new(4).write(to_html(lang), String.new)
  end
  # @private
  def to_html(lang)
    root = REXML::Element.new("table") 
    root.add_attributes({
      "name" => MetroPage.get_text(@name, lang),
      "border" => "0",
      "style" => "text-align:center;",
    })

    # Add rows
    root.add_element("tr") # Title row
    num_row = @columns.map{ |col| col.tiles.size }.max
    num_row.times { root.add_element("tr").add_attribute("style", "height:180px;") }

    # Add columns
    @columns.each_with_index do |col, index|
      # Add the title
      ele = root.elements[1].add_element("td")
      ele.add_attribute("style", "width:180px;float:left;")
      ele.add_element("h3").text = MetroPage.get_text(col.name, lang)

      # Add tiles
      col.tiles.size.times do |i|
        root.elements[2+i].add_element("td").add_element(col.tiles[i].to_html(lang))
      end

      # Add empty tiles
      (col.tiles.size+1).upto(num_row) do |i|
        root.elements[1+i].add_element("td")
      end

      # Add an empty column if next column has a name
      if @columns[index+1].is_a?(MetroPage::Column)
        root.elements[1].add_element("td").add_attribute("style", @columns[index+1].name == "" ? "width:0px;" : "width:50px;")
        num_row.times{ |i| root.elements[2+i].add_element("td") }
      end
    end

    return root
  end
end
