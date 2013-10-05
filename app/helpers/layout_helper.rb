module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def seo_meta_description
    if I18n.locale == :es
      'Entrega y recibe regalos para hacer de este mundo un lugar mejor!'
    else
      'Give away and get gifts to make the world a better place'
    end
  end
end
