#!/usr/bin/env ruby
# encoding: UTF-8

# An abstract single page, the highest level.
class MetroPage::Page
  # The html code to separate tables
  TAB_SEPARATOR = "<hr style=\"margin:40px 0px 40px 0px; background-color:#FFFFFF; color:#FFFFFF; height:1px; border:0;\"/>\n"

  attr_accessor :name, :title, :tables, :left_bottom, :right_bottom, :nav, :no_animation, :no_languages

  # Create a page
  def initialize(
                  name:"", 
                  title:"", 
                  tables:[],

                  left_bottom:["Created by MetroPage v" + MetroPage::VERSION, "https://github.com/aidistan/aidi-metropage"], 
                  right_bottom:"#{Time.now.year}.#{Time.now.mon}.#{Time.now.mday}", 
                  nav:nil,

                  no_animation:false,
                  no_languages:false
                )
    @name = name
    @title = title
    @tables = tables
    @left_bottom = left_bottom
    @right_bottom = right_bottom
    @nav = nav
    @no_animation = no_animation
    @no_languages = no_languages
  end
  # Push a table into the page
  def push(*args)
    @tables.push *args
    return self
  end
  # Build the page
  def build
    MetroPage::LANGUAGES.keys.each {|lang| File.open("index_#{lang}.html", "w").puts self.to_s(lang)}
    if @no_animation
      content = File.open(File.expand_path("../css_template.css", __FILE__)).read.gsub(".metroitem:hover", ".metroitem/*:hover*/")
      File.open("metro_style.css", "w").puts content
    else
      File.open("metro_style.css", "w").puts File.open(File.expand_path("../css_template.css", __FILE__)).read
    end
    return self
  end
  # @private
  def to_s(lang)
    rtn = File.open(File.expand_path("../page_template.html", __FILE__)).read

    rtn.sub!("<!-- MetroPage.page.title -->", MetroPage.get_text(@title, lang))
    rtn.sub!("<!-- MetroPage.page.name -->", MetroPage.get_text(@name, lang))
    rtn.sub!(/^\s+<!-- MetroPage.page.tables -->/) do
      /^(?<indent> +)<!-- MetroPage.page.tables -->/ =~ rtn
      @tables.collect { |tab| tab.to_s(lang).split("\n").collect { |line| indent + line }.join("\n") }.join(TAB_SEPARATOR)
    end

    rtn.sub!("<!-- MetroPage.page.left_bottom -->", "<a href='#{left_bottom[1]}'>#{MetroPage.get_text(left_bottom[0], lang)}</a>")
    rtn.sub!("<!-- MetroPage.page.right_bottom -->", MetroPage.get_text(right_bottom, lang))
    unless @no_languages
      rtn.sub!(/^\s+<!-- MetroPage.LANGUAGES -->/) do
        /^(?<indent> +)<!-- MetroPage.LANGUAGES -->/ =~ rtn
        [
          '<li><a href="#">Language</a>',
          '    <ul class="subs">',
          MetroPage::LANGUAGES.keys.collect{|sym| "<li><a href=\"index_#{sym}.html\">#{MetroPage::LANGUAGES[sym]}</a></li>"},
          '    </ul>',
          '</li>',
        ].flatten.collect! { |line| indent + line }.join("\n")
      end
    end
    if @nav
      rtn.sub!(/^\s+<!-- MetroPage.page.nav -->/) do
        /^(?<indent> +)<!-- MetroPage.page.nav -->/ =~ rtn
        MetroPage::NavigateBar.create(@nav, lang).split("\n").collect { |line| indent + line }.join("\n")
      end
    end

    return rtn
  end
end
