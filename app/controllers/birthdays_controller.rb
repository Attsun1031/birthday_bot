# coding: utf-8
require 'date'

class BirthdaysController < ApplicationController
  before_filter :parse_date_params, :only => ['search']
  after_filter :hold_search_conditions, :only => ['search']

  def index
    @birthdays = Birthday.all
  end

  def new
    @birthday = Birthday.new
  end

  def show
    @birthday = Birthday.find(params[:id])
  end

  def search
    target_date = params[:target_date]
    @birthdays = Birthday.find_by_birthday(target_date)
    session[:target_date] = target_date
    render :action => 'index'
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

  private
  # 検索用日付パラメータを Date オブジェクトに変換する。
  def parse_date_params
    date_params = params[:date]
    unless date_params != nil
      params[:target_date] = session[:target_date]
      return
    end

    year  = date_params[:year].to_i
    month = date_params[:month].to_i
    day   = date_params[:day].to_i
    params[:target_date] = Date.new(year, month, day)
  end

  # 現在の検索条件を保持する。
  def hold_search_conditions
    session[:target_date] = params[:target_date]
  end
end

