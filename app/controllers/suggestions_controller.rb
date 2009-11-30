class SuggestionsController < ApplicationController

  before_filter :admin_required, :except => [:new, :create]

  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion = Suggestion.new(params[:suggestion])

    if @suggestion.save
      flash[:notice] = 'Thanks for your suggestion!'
      redirect_to new_suggestion_url
    else
      render :action => "new"
    end
  end

  def index
    @suggestions = Suggestion.all
  end

  def show
    @suggestion = Suggestion.find(params[:id])
  end

  def destroy
    @suggestion = Suggestion.find(params[:id])
    @suggestion.destroy

    redirect_to suggestions_url
  end
end
