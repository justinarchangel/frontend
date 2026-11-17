// Runs in the browser, not on the server. It asks the app for the posts as data,
// then builds the page from them, one post at a time.
const feed = document.getElementById("feed")

fetch("/posts.json")
  .then(function (response) {
    if (!response.ok) {
      throw new Error("The app answered " + response.status)
    }
    return response.json()
  })
  .then(function (posts) {
    for (const post of posts) {
      const div = document.createElement("div")
      div.className = "post"

      const img = document.createElement("img")
      img.src = post.image
      div.appendChild(img)

      // textContent, never innerHTML: the body is data from a user, so it is shown
      // as text and never run as part of the page
      const p = document.createElement("p")
      p.textContent = post.body
      div.appendChild(p)

      feed.appendChild(div)
    }
  })
  .catch(function (error) {
    feed.textContent = "No posts yet: /posts.json isn't answering with data. (" + error.message + ")"
  })
