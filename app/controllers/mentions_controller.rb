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

  def parse
    @mention = Mention.find(params[:id])
    if @mention.parse!
      flash[:notice] = "Successfully parsed mention."
      redirect_to @mention
    else  
      flash.now[:error] = "Parse error: #{@mention.parse_message}"
      render :action => "show"
    end
  end

  def destroy
    @mention = Mention.find(params[:id])
    @mention.destroy

    redirect_to mentions_url
  end
  
end
