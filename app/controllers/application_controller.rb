# class ApplicationController < ActionController::Base
# end


class ApplicationController < ActionController::Base

  def index
    render :home
  end

  def about
    render :about
  end

  # def hola
  #   render html: "¡Hola rails!"
  # end
end
