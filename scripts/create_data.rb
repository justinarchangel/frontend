Company.destroy_all
Contact.destroy_all
Post.destroy_all
User.destroy_all

# Create companies

apple = Company.new
apple["name"] = "Apple"
apple["city"] = "Cupertino"
apple["state"] = "CA"
apple["url"] = "https://apple.com"
apple.save

amazon = Company.new
amazon["name"] = "Amazon"
amazon["city"] = "Seattle"
amazon["state"] = "WA"
amazon["url"] = "https://amazon.co"
amazon.save

anthropic = Company.new
anthropic["name"] = "Anthropic"
anthropic["city"] = "San Francisco"
anthropic["state"] = "CA"
anthropic["url"] = "https://anthropic.com"
anthropic.save

# Create contacts

tim = Contact.new
tim["first_name"] = "Tim"
tim["last_name"] = "Cook"
tim["email"] = "tim@apple.com"
tim["phone_number"] = "777-777-7777"
tim["company_id"] = apple.id
tim.save

craig = Contact.new
craig["first_name"] = "Craig"
craig["last_name"] = "Federighi"
craig["email"] = "craig@apple.com"
craig["phone_number"] = "888-888-8888"
craig["company_id"] = apple.id
craig.save

andy = Contact.new
andy["first_name"] = "Andy"
andy["last_name"] = "Jassy"
andy["email"] = "andy@amazon.com"
andy["phone_number"] = "666-666-6666"
andy["company_id"] = amazon.id
andy.save

dario = Contact.new
dario["first_name"] = "Dario"
dario["last_name"] = "Amodei"
dario["email"] = "dario@anthropic.com"
dario["phone_number"] = "555-555-5555"
dario["company_id"] = anthropic.id
dario.save

puts "There are now #{Company.all.count} companies and #{Contact.all.count} contacts."

# Create users
#
# Passwords are stored as bcrypt hashes, never as typed. The plain-text rows
# from the old system were moved onto hashes, so Ben and Brian can log in.

ben = User.new
ben["first_name"] = "Ben"
ben["last_name"] = "Block"
ben["email"] = "ben@example.com"
ben["password"] = BCrypt::Password.create("tacos123")
ben.save

brian = User.new
brian["first_name"] = "Brian"
brian["last_name"] = "Uzzi"
brian["email"] = "brian@example.com"
brian["password"] = BCrypt::Password.create("password")
brian.save

puts "There are now #{User.all.count} users."

# Create posts, each one belonging to a user

posts = [
  [ben, "My first Tacostagram post!", "https://images.unsplash.com/photo-1607891715106-ba61a2951650?w=1200&auto=format&fit=crop"],
  [brian, "Yummmm!", "https://images.unsplash.com/photo-1511690078903-71dc5a49f5e3?w=1200&auto=format&fit=crop"],
  [ben, "Taco Tuesday, obviously.", "https://images.unsplash.com/photo-1508154048109-de555266b70a?w=1200&auto=format&fit=crop"],
  [brian, "Found a new spot near campus.", "https://images.unsplash.com/photo-1618414466256-4b62f39b5b30?w=1200&auto=format&fit=crop"]
]

for user, body, image in posts
  post = Post.new
  post["author"] = user["first_name"]
  post["body"] = body
  post["image"] = image
  post["user_id"] = user["id"]
  post.save
end

puts "There are now #{Post.all.count} Tacostagram posts."
