module GiftsHelper

  def show_tags(gift)
    gift.tag_list.map do |tag|
      link_to tag_path(tag) do
        content_tag(:span, tag, :class => 'label label-info')
      end
    end.join(', ').html_safe
  end

  def show_delivery_methods(gift)
    gift.deliveries.map do |delivery|
      delivery.name
    end.join(', ')
  end

  def gift_seo_title(gift)
    s = I18n.locale == :es ? 'en' : 'in'
    if gift.short_address
      [gift.title, s, gift.short_address].join(' ')
    else
      gift.title
    end
  end

  def gift_seo_description(gift)
    truncate(gift.description, length: 90)
  end

  def category_seo_title(category)
    s = I18n.locale == :es ? 'Regalo de' : 'Gifts in'
    [s, category.name].join(' ')
  end

end
