class BrogramsController < ApplicationController
  
  def new
    
  end
  
  def create
    BrogramMailer.brogram(params[:brogram]).deliver
  end
  
end