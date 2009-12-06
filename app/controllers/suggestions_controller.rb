class SuggestionsController < ApplicationController

  before_filter :admin_required, :except => [:new, :create]

  def index
    @suggestions = Suggestion.all(:order => 'created_at desc')
  end

  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion = Suggestion.new(params[:suggestion])

    if @suggestion.save
      redirect_to thanks_suggestion_url(@suggestion)
    else
      render :action => "new"
    end
  end
  
  def destroy
    @suggestion = Suggestion.find(params[:id])
    @suggestion.destroy

    redirect_to suggestions_url
  end
  
  def thanks
    @suggestion = Suggestion.find(params[:id])
    @photos = Photo.most_recent(10)
  end
  
end

