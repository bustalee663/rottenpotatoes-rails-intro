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
    #Load all the ratings from the movie class
    @all_ratings = Movie.ratings


    #Need this for the redirect URI to remain restful
    loaded_session = false

    #Sort problem
    if params[:sort]
      #If we have a param for sort, we want to set sort to this as well as update the session
      @sort = params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      #If there isn't a param but there's a session, we want to load that
      @sort = session[:sort]
      loaded_session = true
    else
      #If neither then no sort so set to nil for query
      @sort = nil
    end

      
    if params[:ratings]
      #use this to keep track in the index view
      @checked_boxes = params[:ratings]
      @movies = Movie.where(rating: @checked_boxes.keys).order(@sort)
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @checked_boxes = session[:ratings]
      @movies = Movie.where(rating: @checked_boxes.keys).order(@sort)
      loaded_session = true
    else #If not just stick to the sort stuff
      #sets up the nil case when we have a new program
      @checked_boxes = []
      @movies = Movie.all.order(@sort)
    end

    #Logic from the readme. If the session was loaded, we want to call redirect to get the URI correct
    if loaded_session 
     flash.keep
     redirect_to movies_path(:sort=>@sort, :ratings=>@checked_boxes)
    end

    @movies
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
