class MemoController < ActionController::Base

  def index
    render :memo
  end

  def images
    # params = request.query_parameters
    if(params[:size].blank?)
      images_count = 16/2
    else
      images_count = params[:size].to_i/2
    end

    if(params[:gallery].blank?)
      gallery = '1_eltex'
    else
      gallery = params[:gallery]
    end
    images_array = []
    images_array_double = []

    # Dir.foreach("/home/app_1/workspace/myapp/public/images/memo/1_eltex"){|x| respond_to.push(name:x) }
    # Dir.each_child("/home/app_1/workspace/myapp/public/images/memo/1_eltex"){|x| respond_to.push(name:x) }
    pair_id = 1;
    Dir.each_child("/home/app_1/workspace/myapp/public/images/memo/"+gallery) do |file|
      images_array.push(pair_id:pair_id,name:file.to_s, src:"/myapp/images/memo/"+gallery+"/"+file,status:'')
      pair_id +=1
    end

    images_array = images_array.shuffle #random before cut
    images_array = images_array[0, images_count] #cut

    images_array.each do |image_hash|
      images_array_double.push(pair_id:image_hash[:pair_id],name:image_hash[:name]+'_double', src:image_hash[:src],status:'')
    end

    images_array = images_array.concat(images_array_double)
    shuffle_arr = images_array.shuffle

    render json: shuffle_arr

  end

end
