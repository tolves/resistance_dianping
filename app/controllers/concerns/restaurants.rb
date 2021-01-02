module Restaurants
  extend ActiveSupport::Concern
  extend BaseController::Methods
  extend ActionView::Helpers::TranslationHelper

  def self.list(city_id, **args)
    restaurants = City.find(city_id).restaurants
    raise "#{City.find(city_id).name} #{t(:doesnt_has_data)}" if restaurants.blank?

    restaurants
  end

  def self.keyboard(restaurants, **args)
    page = args[:page].to_i
    kb = restaurants.limit(pg_offset).offset(page * pg_offset).map { |r| [{ text: "#{r.name}: #{r.description}", callback_data: "show_comments:#{r.id},#{page}" }, { text: t(:link), url: r.link }] }
    kb.push pagination(restaurants, page: page, action: 'edit_restaurants')
    kb.push [{text: t(:forwardable), callback_data: "output_restaurants:#{page}"}]
  end

  def self.create(city, name, description, author)
    city.restaurants.create(name: name, description: description, author: author, confirmation: false)
  end

  def self.update(restaurant, link)
    restaurant.update(dp_link: link)
  end

  def self.output(restaurant, page)
    text = "<b>#{t(:list)}</b> \n"
    restaurant.limit(pg_offset).offset(page.to_i * pg_offset).each do |r|
      text << "#{r.name.html_safe}: #{r.description.html_safe}. <a href=\"#{r.link}\">链接</a> \n"
    end
    text
  end

end