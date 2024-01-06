class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
  @user = User.find(params[:id])
  @books = @user.books
  @book = Book.new
  @posts = @user.posts

  if @posts.any?
    @today_count = @posts.where(date: Date.today).sum(:count)
    @yesterday_count = @posts.where(date: Date.yesterday).sum(:count)
    @difference_percentage = calculate_difference_percentage(@yesterday_count, @today_count)
    @this_week_count = @posts.where(date: (Date.today.beginning_of_week..Date.today)).sum(:count)
    @last_week_count = @posts.where(date: (1.week.ago.beginning_of_week..1.week.ago.end_of_week)).sum(:count)
    @week_difference = @this_week_count - @last_week_count
    @past_seven_days_counts = @posts.where(date: (7.days.ago.beginning_of_day..Date.today.end_of_day)).group_by_day(:date).sum(:count)
  elseif @posts.any?
  # 投稿数を計算して各変数に設定する処理
  else
  # 投稿がない場合のデフォルトの値を設定する
  @today_count = 0
  @yesterday_count = 0
  @difference_percentage = 0
  @this_week_count = 0
  @last_week_count = 0
  @week_difference = 0
  @past_seven_days_counts = {}

    # 投稿がない場合の処理
    # デフォルトの値を設定したり、メッセージを表示したりします
  end

  respond_to do |format|
    format.html
    format.json { render json: { dates: @past_seven_days_counts&.keys, counts: @past_seven_days_counts&.values } }
  end
  end


  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  def calculate_difference_percentage(yesterday_count, today_count)
    return 0 if yesterday_count.zero?
  
    ((today_count - yesterday_count) / yesterday_count.to_f) * 100
  end
end
