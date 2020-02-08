class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Default all ratings to the function from the model
    @all_ratings = Movie.all_ratings
    # Helps transfer
    load = false

    # Sorting functions based on if there are previous sorting or not
    if params[:sort]
      @sort = params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
      load = true
    else
      @sort = nil
    end

    # Similar to the sorting but for ratings
    if params[:ratings]
      @checked_boxes = params[:ratings]
      @movies = Movie.where(rating: @checked_boxes.keys).order(@sort)
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @checked_boxes = session[:ratings]
      @movies = Movie.where(rating: @checked_boxes.keys).order(@sort)
      load = true
    else
      @checked_boxes = @all_ratings
      @movies = Movie.all.order(@sort)
    end
    
    # If the session was loaded, call the redirect to have the correct URI
    if load 
     flash.keep
     redirect_to movies_path(:sort=>@sort, :ratings=>@checked_boxes)
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
