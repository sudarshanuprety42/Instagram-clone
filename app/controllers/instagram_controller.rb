class InstagramController < ApplicationController
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_action :authenticate_user!
  def index
    @post = Post.new

    current_followings = current_user.followings.pluck(:flwg).to_a
    if !current_followings.empty?
      @feed = User.find(current_followings[0]).posts.order(created_at: :desc)
      current_followings.each do |fid|
        @feed+=(User.find(fid).posts.order(created_at: :desc))
      end
      @feed=@feed.uniq
      @feed.sort
    else
      @feed = nil
    end
    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a
    @feed = @feed.sort_by(&:created_at).reverse
  end

  def currentuser
    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a
  end

  def edit_profile
    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a
  end

  def update_profile
    test = true
    if !valid_email?(update_params['email'])
      flash[:error] = "Invalid email"
      test = false
    end
    if update_params[:username].empty? || update_params[:username].length<6
      flash[:error] = "Invalid username"
      test = false
    end
    if update_params[:fullname].empty? || update_params[:fullname].length<6
      flash[:error] = "Invalid fullname"
      test = false
    end
    if test
      current_user.email=update_params['email']
      current_user.username=update_params['username']
      current_user.fullname=update_params['fullname']
      current_user.gender=update_params['gender']
      current_user.bio=update_params['bio']
      current_user.save
      flash[:notice] = "Updated Successfully."
      @followings = current_user.followings.pluck(:flwg).to_a
      @followers = current_user.followers.pluck(:flwr).to_a
      redirect_to :action=>'currentuser'
    else
      redirect_back(fallback_location: root_path)
    end
  end


  def edit_password
  end
  def update_password
    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a

    if pw_params[:newpw].empty?
      flash[:error] = "Enter password"
      redirect_to :action=>'edit_password'
    elsif pw_params[:newpw].length<6
      flash[:error] = "Password must be atleast of length six"
      redirect_to :action=>'edit_password'
    elsif pw_params[:newpw]!=pw_params[:conpw]
      flash[:error] = "Password don't match."
      redirect_to :action=>'edit_password'
    elsif current_user.valid_password?(pw_params[:oldpw])
      current_user.password=pw_params[:newpw]
      current_user.save
      redirect_to :action=>'currentuser'
    else
      flash[:error] = "Incorrect password."
      redirect_to :action=>'edit_password'
    end
  end

  def update_dp
    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a
    if params[:user].nil?
      flash[:error] = "Invalid image."
      redirect_to :action=>'currentuser'
    elsif !params[:user].has_key?(:dp)
      flash[:error] = "Invalid image."
      redirect_to :action=>'currentuser'
    elsif !dp_params[:dp].content_type.in?(%('image/jpeg image/png'))
      flash[:error] = "Invalid image."
      redirect_to :action=>'currentuser'
    else
      current_user.display_picture.purge
      current_user.display_picture=dp_params[:dp]
      current_user.save
      redirect_to :action=>'currentuser'
    end
  end

  def search_user
    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a
    @kw = search_params[:keyword]
    @users = User.where("username LIKE :search OR fullname LIKE :search", search: "%#{@kw}%").where.not(email: current_user.email)

  end

  def follow
    user = User.find(follow_params[:id])
    f = current_user.followings.where("flwg=#{user.id}")
    if f.exists?
     Following.where("flwg=#{user.id} and user_id=#{current_user.id}").delete_all
     Follower.where("flwr=#{current_user.id} and user_id=#{user.id}").delete_all
    else
      current_user.followings.new(:user_id=>current_user.id, :flwg=>user.id).save
      user.followers.create(:user_id=>user.id, :flwr=>current_user.id)
    end

    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a
    redirect_back(fallback_location: root_path)
  end

  def show_user
    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a

    @user = User.find(show_params[:id])
    if current_user == @user
      redirect_to :action=>'currentuser'
    end

    @user_followings = @user.followings.pluck(:flwg).to_a
    @user_followers = @user.followers.pluck(:flwr).to_a

  end

  def followers
    @user = User.find(follower_params[:id])
    followers_ids = @user.followers.pluck(:flwr).to_a
    @flwr = User.find( followers_ids )

     @followings = current_user.followings.pluck(:flwg).to_a
  end

  def followings
    @user = User.find(follower_params[:id])
    followings_ids = @user.followings.pluck(:flwg).to_a
    @flwg = User.find( followings_ids )

    @followings = current_user.followings.pluck(:flwg).to_a
  end

  private
  def update_params
    params.require(:user).permit(:email,:username, :fullname , :gender, :bio)
  end
  def pw_params
    params.require(:user).permit(:oldpw,:newpw, :conpw )
  end
  def dp_params
    params.require(:user).permit(:dp)
  end
  def search_params
    params.require(:search).permit(:keyword)
  end
  def follow_params
    params.permit(:id)
  end

  def show_params
    params.permit(:id)
  end

  def follower_params
    params.permit(:id)
  end

  def email_dont_exist(email)
     User.find_by(email: email).nil? || User.find_by(email: email).eql?(current_user)
  end

  def valid_email?(email)
    email.present? &&
     (email =~ VALID_EMAIL_REGEX) && email_dont_exist(email)
  end




end
