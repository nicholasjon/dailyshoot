class MentionsController < ApplicationController
  
  before_filter :admin_required
  
  def index
    @mentions = Mention.pending
  end

  def show
    @mention = Mention.find(params[:id])
  end

  def edit
    @mention = Mention.find(params[:id])
  end

  def update
    @mention = Mention.find(params[:id])
    if @mention.update_attributes(params[:mention])
      flash[:notice] = 'Mention was successfully updated.'
      redirect_to @mention
    else
      render :action => "edit"
    end
  end

  def destroy
    @mention = Mention.find(params[:id])
    @mention.destroy
    redirect_to mentions_url
  end
  
end
