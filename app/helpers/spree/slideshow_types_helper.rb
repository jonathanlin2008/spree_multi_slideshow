module Spree
  module SlideshowTypesHelper

    def insert_slideshow(params={})
      @content_for_head_added ||= false
      if not @content_for_head_added
        content_for(:head) { stylesheet_link_tag 'store/spree_multi_slideshow.css' }
        content_for(:head) { javascript_include_tag 'store/spree_multi_slideshow.js' }
        @content_for_head_added = true
      end
      if slide_images(params)
        navigation = enable_navigation(params)
        #content_tag(:div, navigation[:prev] + content_tag(:div, content_tag(:ul, raw(slide_images(params)), :id => 'gallery_slide_cycle'), :class => "frame") + navigation[:succ], :class => "gallery #{params[:class]}", :style => "width: #{Spree::SlideshowType.enable(params[:category] || "home").first.slide_width}px; height: #{Spree::SlideshowType.enable(params[:category] || "home").first.slide_height}px;")
        config_data = Spree::SlideshowType.enable(params[:category] || "home").first
        slide_width= "#{config_data.slide_width}px"
        slide_height = "#{config_data.slide_height}px"
        thumbnail_width= "#{config_data.thumbnail_width}px"
        thumbnail_height = "#{config_data.thumbnail_height}px"
        con_thumbnail = content_tag(:div, raw(slide_images(params,false,:width => thumbnail_width, :height => thumbnail_height, :class => 'thumbnail_other')), :id => 'slideshow_paper', :style => 'width:#{thumbnail_width};height:#{thumbnail_height};float:right;clear:both;')
        con_slide = content_tag(:div, raw(slide_images(params,true,:width => slide_width, :height => slide_height)), :id => 'gallery_slide_cycle')
        output_html = content_tag(:span);
        if config_data.enable_thumbnail
          output_html += con_thumbnail
        end
        if config_data.enable_slide
          output_html += con_slide
        end
        output_html
      end
    end

    def slide_images(params, want_link=true, image_prop={:height => '100px', :width => '100px', :border => '0px', :class => ''})
      category = params[:category] || "home"
      style = params[:style] || "custom"
      slideshow = Spree::SlideshowType.enable(category)
      if !slideshow.blank?
        max = slideshow.first.slide_number || 4
        slides = Spree::Slide.where("slideshow_type_id = ?", slideshow.first.id).limit(max).sort_by { |slide| slide.position }
        if want_link
          slides.map do |slide|
            #content_tag(:li, raw(link_to(image_tag(slide.attachment.url(style.to_sym)), slide.url, { :title => slide.title })) + raw(content_tag(:div, content_tag(:strong, raw(slide.title)) + content_tag(:p, raw(slide.content)), :class => "text-holder")))
            image_link = image_tag('/spree/slides/'+slide.attributes.fetch('id').to_s()+'/original_'+slide.attributes.fetch('attachment_file_name'),:style => "width: #{image_prop[:width]}; height: #{image_prop[:height]};", :class => "#{image_prop[:class]}")
            image_link = link_to(image_link, slide.attributes.fetch('url'))
          end.join
        else
          n = -1
          slides.map do |slide|
            #content_tag(:li, raw(link_to(image_tag(slide.attachment.url(style.to_sym)), slide.url, { :title => slide.title })) + raw(content_tag(:div, content_tag(:strong, raw(slide.title)) + content_tag(:p, raw(slide.content)), :class => "text-holder")))
            n += 1
            image_link = image_tag('/spree/slides/'+slide.attributes.fetch('id').to_s()+'/original_'+slide.attributes.fetch('attachment_file_name'),:style => "width: #{image_prop[:width]}; height: #{image_prop[:height]};", :class => "#{image_prop[:class]}", :alt => n)
          end.join
        end
      else
        false
      end
    end

    def enable_navigation(params)
      container_nav = params[:container_navigation] || ''
      cl_nav_container = params[:class_navigation_container] ? params[:class_navigation_container].split(",") : ''
      cl_nav_link = params[:class_navigation_link] ? params[:class_navigation_link].split(",") : ''
      category = params[:category] || "home"
      slideshow = Spree::SlideshowType.enable(category)
      if !slideshow.blank?
        prev = link_to("prev", "#")
        succ = link_to("next", "#")
=begin
        if slideshow.first.enable_navigation
          prev = link_to("prev", "#", :class => "prev #{cl_nav_link[0]}")
          succ = link_to("next", "#", :class => "next #{cl_nav_link[1]}")
        else
          prev = ""
          succ = ""
        end
=end

        unless container_nav.blank?
          prev = content_tag(container_nav.to_sym, prev, :class => cl_nav_container[0])
          succ = content_tag(container_nav.to_sym, succ, :class => cl_nav_container[1])
        end

        res = Hash.new()
        res[:prev] = prev
        res[:succ] = succ
        return res
      end
    end

  end
end