class TopController < ApplicationController
  def index
    if current_user
      redirect_to mypage_path
    end
  end
end
