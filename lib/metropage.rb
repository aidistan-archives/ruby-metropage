#!/usr/bin/env ruby
# encoding: UTF-8

# Top namespace
module MetroPage
  # Current version number
  VERSION = "0.6.1"

  module_function

  # Text getter function used in all places where we need to show text
  # @example Text definitions in MetroPage
  #   tile = MetroPage::Tile.new
  #   tile.title = "Me"
  #   # Or more flexible
  #   tile.title = { en:"Me", cn:"我" }
  def get_text(obj, lang)
    case obj
    when String then obj
    when Hash   then obj[lang]
    else ""
    end
  end
end

# Requisitions
require "rexml/document"
require "metropage/tile"
require "metropage/column"
require "metropage/table"
require "metropage/navigatebar"
require "metropage/page"
