#!/usr/bin/env ruby
# encoding: UTF-8

# Used to create a navigate bar
module MetroPage::NavigateBar
  module_function
  
  # Create top level menu
  def create(hash, lang)
    hash.collect do |key, value|
      if value.is_a?(String)
        "<li><a href='#{value}'>#{MetroPage.get_text(key, lang)}</a></li>\n"
      elsif value[:children]
        "<li><a href='#{value[:href]}'>#{MetroPage.get_text(key, lang)}</a>\n" + 
        sub_create(value[:children], lang).split("\n").collect { |line| " "*4 + line }.join("\n") + 
        "</li>\n"
      else
        "<li><a href='#{value[:href]}'>#{MetroPage.get_text(key, lang)}</a></li>\n"
      end
    end.join
  end
  # Create sub menu
  def sub_create(hash, lang)
    '<ul class="subs">' + 
    hash.collect do |key, value|
      if value.is_a?(String)
        "    <li><a href='#{value}'>#{MetroPage.get_text(key, lang)}</a></li>\n"
      elsif value[:children]
        "    <li><a href='#{value[:href]}'>#{MetroPage.get_text(key, lang)}</a>\n" + 
        sub_create(value[:children]).split("\n").collect { |line| " "*8 + line }.join("\n") + 
        "    </li>\n"
      else
        "    <li><a href='#{value[:href]}'>#{MetroPage.get_text(key, lang)}</a></li>\n"
      end
    end.join +
    '</ul>'
  end
end
