#!/usr/bin/env ruby
# encoding: UTF-8

# Basic elements in MetroPage
class MetroPage::Tile
  # Default colors
  PALLET = ["#00aeef", "#ea428a", "#eed500", "#f5a70d", "#8bcb30", "#9962c1"]

  attr_accessor :name, :url, :title, :content, :a_href, :a_target
  attr_accessor :icon_img_src, :icon_txt, :icon_txt_before, :icon_txt_after, :icon_txt_color, :icon_txt_size
  attr_accessor :other_rubybadge, :other_hook

  # Create a Tile
  # See source codes for more details.
  def initialize(
                  name:"", 
                  url:"#", 
                  title:"", 
                  content:"",
                  a_href:nil,
                  a_target:"_blank",

                  icon_img_src:nil,
                  icon_txt:nil,
                  icon_txt_before:"<tr><td>",
                  icon_txt_after:"</td></tr>",
                  icon_txt_color:PALLET[rand(PALLET.size)],
                  icon_txt_size:20,

                  other_rubybadge:nil,
                  other_hook:nil
                )
    @name = name
    @url = url
    @title = title
    @content = content
    @a_href = a_href || url
    @a_target = a_target

    @icon_img_src   = icon_img_src
    @icon_img_src ||= "images/#{name}.png" if FileTest.exist?("images/#{name}.png")
    @icon_img_src ||= "images/#{name}.jpg" if FileTest.exist?("images/#{name}.jpg")
    @icon_img_src ||= "images/#{name}.png" # Default value even if not exists
    @icon_txt = icon_txt
    @icon_txt_before = icon_txt_before
    @icon_txt_after = icon_txt_after
    @icon_txt_color = icon_txt_color
    @icon_txt_size = icon_txt_size

    @other_rubybadge = other_rubybadge
    @other_hook = other_hook
  end
  # @private
  def to_s(lang)
    REXML::Formatters::Pretty.new(4).write(to_html(lang), String.new)
  end  
  # @private
  def to_html(lang)
    root = REXML::Element.new("div")
    root.add_attribute("class", "metroitem")

    # Icon
    ele = root.add_element("a")
    ele.add_attributes({
      "href" => @a_href,
      "target" => @a_target,
    })
    if icon_txt # text
      ele = ele.add_element("table")
      ele.add_attributes({
        "class" => "icon",
        "style" => "background-color: #{@icon_txt_color}; font-size: #{@icon_txt_size}px; line-height: #{@icon_txt_size*1.5}px;",
      })
      ele.add_element(REXML::Document.new(@icon_txt_before + MetroPage.get_text(@icon_txt, lang) + @icon_txt_after).root)
    else # image
      ele.add_element("img").add_attributes({
        "class" => "icon",
        "alt"   => @name,
        "src"   => @icon_img_src,
      })
    end

    # Title
    ele = root.add_element("h4")
    ele.add_attribute("class", lang.to_s)
    ele.text = MetroPage.get_text(@title, lang)

    # Content
    MetroPage.get_text(@content, lang).split("\n").each do |p|
      ele = root.add_element(REXML::Document.new("<p class='#{lang}'>#{p}</p>").root)
    end

    # Others
    if @other_rubybadge
      ele = root.add_element("a")
      ele.add_attribute("href", @other_rubybadge)
      ele.add_element("img").add_attributes({
        "class" => "rubybadge",
        "src" => @other_rubybadge + "@2x.png"
      })
    end
    if @other_hook
      root.add_element(REXML::Document.new(@other_hook).root)
    end

    return root
  end
end
