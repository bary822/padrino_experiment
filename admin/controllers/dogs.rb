PadrinoExperiment::Admin.controllers :dogs do
  get :index do
    @title = "Dogs"
    @dogs = Dog.all
    render 'dogs/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'dog')
    @dog = Dog.new
    render 'dogs/new'
  end

  post :create do
    @dog = Dog.new(params[:dog])
    if (@dog.save rescue false)
      @title = pat(:create_title, :model => "dog #{@dog.id}")
      flash[:success] = pat(:create_success, :model => 'Dog')
      params[:save_and_continue] ? redirect(url(:dogs, :index)) : redirect(url(:dogs, :edit, :id => @dog.id))
    else
      @title = pat(:create_title, :model => 'dog')
      flash.now[:error] = pat(:create_error, :model => 'dog')
      render 'dogs/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "dog #{params[:id]}")
    @dog = Dog[params[:id]]
    if @dog
      render 'dogs/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'dog', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "dog #{params[:id]}")
    @dog = Dog[params[:id]]
    if @dog
      if @dog.modified! && @dog.update(params[:dog])
        flash[:success] = pat(:update_success, :model => 'Dog', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:dogs, :index)) :
          redirect(url(:dogs, :edit, :id => @dog.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'dog')
        render 'dogs/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'dog', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Dogs"
    dog = Dog[params[:id]]
    if dog
      if dog.destroy
        flash[:success] = pat(:delete_success, :model => 'Dog', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'dog')
      end
      redirect url(:dogs, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'dog', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Dogs"
    unless params[:dog_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'dog')
      redirect(url(:dogs, :index))
    end
    ids = params[:dog_ids].split(',').map(&:strip)
    dogs = Dog.where(:id => ids)
    
    if dogs.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Dogs', :ids => "#{ids.join(', ')}")
    end
    redirect url(:dogs, :index)
  end
end
