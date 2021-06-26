# class ApplicationController < ActionController::Base
# end


class ActorsController < ActionController::Base

  def index
    @actors = Actor.all
    render :actors
  end
  def show
    #model
    # ActiveRecord::Base.connection.tables
    # table_exist = ActiveRecord::Base.connection.table_exists? 'actors' #table_exist.to_s

    #assembly variables to view

    @actor_id = params[:id].to_s
    @actor = Actor.find(@actor_id)

    #pagination
    @ids = Actor.all.ids
    @current_index = params[:id].to_i

    @previous_index = @current_index -1
    if @previous_index < @ids.first
      @previous_index = @ids.last
    end
    @next_index = @current_index +1
    if @next_index > @ids.last
      @next_index = @ids.first
    end

    render :actor

    # render html: 'Table exists?: '+ table_exist.to_s
  end

  def scrapper
    require 'open-uri'
    require 'nokogiri'

    user_agents =[
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Safari/605.1.15 Version/13.0.4',
      'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)',
      'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1',
      'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 6P Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.83 Mobile Safari/537.36',
      'Mozilla/5.0 (Linux; Android 6.0.1; SGP771 Build/32.2.A.0.253; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/52.0.2743.98 Safari/537.36',
      'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246',
      'Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.64 Safari/537.36'
    ]
    # url = 'https://www.kinopoisk.ru/name/12086/'
    # url = 'https://www.kinopoisk.ru/name/40779/'
    # url = 'https://bakunova.ru/server/server.php'
    url = 'https://lowpowerart.com'
    html = open(url,
      "User-Agent" =>user_agents.shuffle.first,
      "Referer" => "http://novoselovilya.ru/actors-scrapper/"
    )
    # @page_data = html.read #open-uri read

    #nokogiri
    doc = Nokogiri::HTML(html)
    images = []
    doc.css('.media').each do |showing|
      img_src = showing['src']
      img_alt = showing['alt']

      images.push(
        src: 'https://lowpowerart.com/'+img_src.to_s,
        alt: img_alt
      )
    end
    @actor_image = images.shuffle.first

    render :scrapper
  end

end
