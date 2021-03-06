class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @sort = params[:sort]
    @ratingHash = params[:ratings]
    
    if @sort == nil && @ratingHash == nil && !session.empty?
      flash.keep
      redirect_to movies_path(:sort => session[:sort], 
          :ratings => session[:ratings])
    else
      session.clear
      session[:sort] = @sort
      session[:ratings] = @ratingHash
    end
    
    
    if @ratingHash != nil
       @ratings = @ratingHash.keys
   else
      @ratings = @all_ratings
   end
    
  @movies = Movie.find_all_by_rating(@ratings, :order => @sort)
  
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
