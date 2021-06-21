# class ApplicationController < ActionController::Base
# end


class ApplicationController < ActionController::Base

  def hello
    render html: "Nslv rails!"
  end
end
