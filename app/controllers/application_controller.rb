class ApplicationController < ActionController::Base
  # Runs before every action in every controller.
  before_action :find_current_user

  def find_current_user
    # the session is a small, signed box that travels with the browser as a cookie;
    # logging in puts the user's id in it, logging out empties it
    @current_user = User.find_by({ "id" => session["user_id"] })
  end

  # Use as a before_action on actions that only members may reach.
  # Rails runs it after find_current_user, so @current_user is already set.
  def require_login
    if @current_user.nil?
      # nobody is logged in: send the visitor to the login form instead
      flash["notice"] = "You must be logged in to do that."
      redirect_to("/login")
    end
  end
end
