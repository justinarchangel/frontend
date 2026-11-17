require "test_helper"

class PostsPageTest < ActionDispatch::IntegrationTest

  test "The feed at /posts still shows every post to a visitor who is not logged in." do
    first_post = Post.new
    first_post["author"] = "Pat"
    first_post["body"] = "Carnitas for days"
    first_post.save

    second_post = Post.new
    second_post["author"] = "Sam"
    second_post["body"] = "Al pastor forever"
    second_post.save

    get("/posts")

    assert_response(:success)
    assert_includes(response.body, "Carnitas for days")
    assert_includes(response.body, "Al pastor forever")
  end

  test "A visitor who is not logged in and opens the new post page is sent to the login page instead." do
    get("/posts/new")

    assert_redirected_to("/login")
  end

  test "A visitor who is not logged in and submits the form does not create a post, and is sent to the login page." do
    posts_before = Post.count

    post("/posts", :params => { "author" => "Anon", "body" => "Sneaky taco", "image" => "" })

    assert_equal(posts_before, Post.count)
    assert_redirected_to("/login")
  end

  test "The new post form has fields for the body and the image, and no field for the author." do
    sign_up_and_log_in("Pat")

    get("/posts/new")

    assert_response(:success)
    assert_select("form input[name=body]")
    assert_select("form input[name=image]")
    assert_select("form input[name=author]", 0)
  end

  test "Submitting the form creates a post whose user_id is the id of the logged-in user, taken from the session and never from the form." do
    pat = sign_up_and_log_in("Pat")
    sam = create_user("Sam")

    # the form smuggles in someone else's id; it must be ignored
    post("/posts", :params => { "body" => "Carnitas for days", "image" => "", "user_id" => sam["id"] })

    created_post = Post.find_by({ "body" => "Carnitas for days" })
    assert_equal(pat["id"], created_post["user_id"])
    assert_not_equal(sam["id"], created_post["user_id"])
  end

  test "On the feed, a post shows the first name of the user it belongs to." do
    pat = create_user("Pat")

    taco_post = Post.new
    taco_post["body"] = "Carnitas for days"
    taco_post["user_id"] = pat["id"]
    taco_post.save

    get("/posts")

    assert_response(:success)
    assert_select("h3", "Pat")
  end

  test "On the feed, each post that belongs to the logged-in user has a Delete button." do
    pat = sign_up_and_log_in("Pat")
    sam = create_user("Sam")
    pats_post = create_post(pat, "Carnitas for days")
    sams_post = create_post(sam, "Al pastor forever")

    get("/posts")

    assert_response(:success)
    assert_select("form[action='/posts/#{pats_post["id"]}'] button", "Delete")
    assert_select("form[action='/posts/#{sams_post["id"]}']", 0)
  end

  test "Pressing it deletes that post and sends the user back to the feed, where the post is gone." do
    pat = sign_up_and_log_in("Pat")
    pats_post = create_post(pat, "Carnitas for days")

    delete("/posts/#{pats_post["id"]}")

    assert_redirected_to("/posts")
    assert_nil(Post.find_by({ "id" => pats_post["id"] }))
    follow_redirect!
    assert_not_includes(response.body, "Carnitas for days")
  end

  test "The button sends a DELETE request to /posts/:id, following the pattern used for companies." do
    pat = sign_up_and_log_in("Pat")
    pats_post = create_post(pat, "Carnitas for days")

    get("/posts")

    assert_select("form[action='/posts/#{pats_post["id"]}'][method=post]") do
      assert_select("input[type=hidden][name=_method][value=delete]")
    end
  end

  test "Signed in as a different user, the feed shows no Delete button on a post that is not mine." do
    sign_up_and_log_in("Pat")
    sam = create_user("Sam")
    sams_post = create_post(sam, "Al pastor forever")

    get("/posts")

    assert_response(:success)
    assert_includes(response.body, "Al pastor forever")
    assert_select("form[action='/posts/#{sams_post["id"]}']", 0)
  end

  test "Signed in as a different user, a DELETE request to /posts/:id for a post that is not mine is refused: the post is still there afterwards." do
    sign_up_and_log_in("Pat")
    sam = create_user("Sam")
    sams_post = create_post(sam, "Al pastor forever")

    delete("/posts/#{sams_post["id"]}")

    assert_redirected_to("/posts")
    assert_not_nil(Post.find_by({ "id" => sams_post["id"] }))
  end

  test "Not signed in at all, a DELETE request to /posts/:id is refused the same way." do
    sam = create_user("Sam")
    sams_post = create_post(sam, "Al pastor forever")

    delete("/posts/#{sams_post["id"]}")

    assert_redirected_to("/login")
    assert_not_nil(Post.find_by({ "id" => sams_post["id"] }))
  end

  private

  # Builds a Post the way posts_controller#create does, owned by the given user.
  def create_post(user, body)
    taco_post = Post.new
    taco_post["body"] = body
    taco_post["user_id"] = user["id"]
    taco_post.save
    taco_post
  end

  # Builds a User the way users_controller#create does, with a known password.
  def create_user(first_name)
    user = User.new
    user["first_name"] = first_name
    user["last_name"] = "Tester"
    user["email"] = "#{first_name.downcase}@example.com"
    user["password"] = BCrypt::Password.create("password")
    user.save
    user
  end

  # Creates a User and logs them in through /login, as sessions_controller expects.
  def sign_up_and_log_in(first_name)
    user = create_user(first_name)
    post("/login", :params => { "email" => user["email"], "password" => "password" })
    user
  end

end
