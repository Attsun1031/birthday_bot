class BirthdaysController < ApplicationController
  def index
    @birthdays = Birthday.all
  end

  def new
    @birthday = Birthday.new
  end

  def show
    @birthday = Birthday.find(params[:id])
  end

  def create
    @birthday = Birthday.new(params[:birthday])
    respond_to do |format|
      if @birthday.save
        format.html { redirect_to(@birthday, :notice => 'Birthday was sacessfully created.') }
      else
        format.html { render :action => 'new' }
      end
    end
  end
end
