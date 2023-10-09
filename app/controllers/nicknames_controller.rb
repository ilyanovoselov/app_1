# class ApplicationController < ActionController::Base
# end


class NicknamesController < ActionController::Base

  def index
    @nicknames = Nickname.all

    properties = Nickname.where("part = 'property'")
    animals = Nickname.where("part = 'animal'")

    @result_nickname = {:property => properties.sample[:value].to_s, :animal => animals.sample[:value].to_s}
    render json: @result_nickname
  end

end
