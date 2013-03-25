# coding: utf-8

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
    if @birthday.save
      redirect_to(@birthday, :notice => 'Birthday was sucessfully created.')
    else
      render :action => 'new'
    end
  end

  def edit
    @birthday = Birthday.find(params[:id])
  end

  def update
    @birthday = Birthday.find(params[:id])
    if @birthday.update_attributes(params[:birthday])
      redirect_to(@birthday, :notice => 'Birthday was successfully updated.')
    else
      render :action => 'edit'
    end
  end

  def destroy
    @birthday = Birthday.find(params[:id])
    @birthday.destroy
    redirect_to(birthdays_url)
  end
end
