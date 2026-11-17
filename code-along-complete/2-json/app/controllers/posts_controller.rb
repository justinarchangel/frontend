class PostsController < ApplicationController
  # Only members can post: anonymous visitors may read the feed (index) but are
  # sent to the login page before new or create runs.
  before_action(:require_login, { :only => ["new", "create", "destroy"] })

  def index
    # find all Post rows
    @posts = Post.all
    if params["format"] == "json"
      # the same rows, as data instead of a page: /posts.json
      render({ :json => @posts })
    else
      # render posts/index view
      render({ :template => "posts/index" })
    end
  end

  def new
    # render posts/new view, the form for a new Post
    render({ :template => "posts/new" })
  end

  def create
    # start with a new Post
    post = Post.new
    # assign the form's values to the Post's columns
    post["body"] = params["body"]
    post["image"] = params["image"]
    # the author is whoever is logged in, read from the session (via @current_user),
    # never from the form, so nobody can post as someone else
    post["user_id"] = @current_user["id"]
    # save the Post row
    post.save
    # redirect the user
    redirect_to("/posts")
  end

  def destroy
    # find the Post whose id is in the address, but only among the logged-in
    # user's own posts, so nobody can delete someone else's by guessing an id
    post = Post.find_by({ "id" => params["id"], "user_id" => @current_user["id"] })
    # destroy the Post row, if it is theirs
    if post
      post.destroy
    end
    # redirect the user back to the feed
    redirect_to("/posts")
  end

end
