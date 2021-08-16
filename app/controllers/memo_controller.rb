class MemoController < ActionController::Base

  def index
    render :memo
  end

  def images
    images_array = []

    # Dir.foreach("/home/app_1/workspace/myapp/public/images/memo/1_eltex"){|x| respond_to.push(name:x) }
    # Dir.each_child("/home/app_1/workspace/myapp/public/images/memo/1_eltex"){|x| respond_to.push(name:x) }
    Dir.each_child("/home/app_1/workspace/myapp/public/images/memo/1_eltex") do |format|
      images_array.push(name:format.to_s, src:"images/memo/1_eltex/"+format)
      images_array.push(name:format.to_s+"_double", src:"images/memo/1_eltex/"+format)
    end

    shuffle_arr = images_array.shuffle

    render json: shuffle_arr

    # msg = { :name => "ok", :message => "Success!", :html => "<b>...</b>" }
    # render :json => msg  # don't do msg.to_json
  end

end
