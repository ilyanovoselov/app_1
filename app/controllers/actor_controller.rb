# class ApplicationController < ActionController::Base
# end


class ActorController < ActionController::Base

  def index
    @actors = Actor.all
    render :actors
  end
  def actor
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

end
