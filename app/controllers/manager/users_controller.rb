class Manager::UsersController < ApplicationController
  before_filter :logged?, :current_user, :manager?, except: [:new, :create]
  respond_to :html

  def index
    @employees = User.employees(@current_user.company_id) if @current_user.company_id.present?
  end

  def new
    @manager = User.new
  end

  def create
    @manager = User.new(params[:user])
    @manager.manager = true

    if @manager.save
      session[:id] = @manager.id
      session[:name] = @manager.name
      session[:manager] = @manager.manager?
      redirect_to action: :index
    else
      flash[:notice] = @manager.errors.full_messages
      redirect_to action: :new
    end
  end

  def edit
    @manager = User.find(params[:username])
  end

  def update
    @manager = User.find_by_username(params[:username])

    if @manager.update_attributes(params[:user])
      redirect_to manager_user_path
    else
      flash[:notice] = @manager.errors.full_messages
      redirect_to action: :edit
    end
  end

end
