require 'spec_helper'

describe LoginController do
  it "should get login" do
    get :login
    response.should be_successful
  end
  it "should not login without email and password" do
    post :login
    flash[:notice].should eql "Invalid email or password"
  end
  it "should not login without email" do
    post :login, { password: "pass" }
    flash[:notice].should eql "Invalid email"
  end
  it "should not login without password" do
    post :login, { email: "email@email.com" }
    flash[:notice].should eql "Invalid password"
  end
  it "should not login with invalid email" do
    post :login, { email: "email@e", password: "pass" }
    flash[:notice].should eql "Invalid email or password"
  end
  it "should not login with invalid password" do
    user = FactoryGirl.build(:user)
    post :login, { email: user.email, password: "oi" }
    flash[:notice].should eql "Invalid email or password"
  end
  it "should login with valid information" do
    user = FactoryGirl.create(:user, plain_password: "pass", manager: true)
    post :login, { email: user.email, password: "pass" }
    session[:id].should eql user.id
    session[:name].should eql "#{user.first_name} #{user.last_name}"
    session[:manager].should eql user.manager?
  end
  it "should logout" do
    get :logout
    session[:id].should eql nil
    session[:name].should eql nil
    session[:manager].should eql nil
    expect(response).to redirect_to action: :login
  end
end
