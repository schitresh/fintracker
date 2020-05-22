class StocksController < ApplicationController
  skip_before_action :authenticate_user!
  
  def search
    if params[:stock].blank?
      flash[:danger] = "Search string is empty."
    else
      @stock = Stock.new_from_lookup(params[:stock])
      flash.now[:danger] = "You've entered incorrect symbol." unless @stock
    end

    respond_to do |format|
      format.js { render partial: 'users/result' }
    end
  end
end

# render json: @stock