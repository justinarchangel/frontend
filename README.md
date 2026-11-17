# frontend

Tacostagram, finished enough to show people. Visitors sign up and log in, posts belong to the
people who made them, and only the owner can delete one. What's left is how it looks, and who
else can read it: the same posts as data, for a page that draws itself or a phone app.

## Getting started

1. On this repo's GitHub page, choose **Use this template**, then **Create a new repository**.
   Make the copy in your own account and choose **Private**.
2. On your copy, choose **Code**, then **Codespaces**, then **Create codespace on main**. The
   first start takes a few minutes: it installs the gems and the agent CLIs, and creates the
   database with its rows.
3. In the terminal, start the app:

       bin/rails server

   Leave that terminal running; open a second one for everything else. When the Codespace
   offers to open port 3000 in the browser, take it (or find it later under **Ports**). The
   home page lists every page in the app; click **Tacostagram**.

If the server isn't running, the browser shows "connection refused" or a 502. Start it again
with `bin/rails server`.

## The accounts

Two users are in the table:

| Email | Password |
|---|---|
| ben@example.com | tacos123 |
| brian@example.com | password |

Their passwords are stored as bcrypt hashes, never as typed; `/data` shows what the table
really holds. Sign up as yourself too.

Logging in (`sessions#create`) finds the user by email, checks the password against the hash,
and puts the user's `id` in the session, a small signed cookie the browser sends back with
every request. `app/controllers/application_controller.rb` turns that id into `@current_user`
before every action. Posts use it: only a logged-in user can post, a new post takes its
`user_id` from the session (never from the form), and only the owner sees a Delete button or
can delete. The tests in `test/integration/posts_page_test.rb` say so, one test per rule;
`bin/rails test` runs them.

## The look

The pages are plain HTML with almost no styling. Making them look like a product starts with a
mockup, not with code: see `mockups/README.md`. The stylesheet is
`app/assets/stylesheets/application.css`, and the layout every page shares is
`app/views/layouts/application.html.erb`.

## The same posts, as data

`/spa/index.html` (the file is `public/spa/index.html`, with `public/spa/app.js`) is a page the
server doesn't build. The browser runs `app.js`, which asks the app for `/posts.json` and draws
the feed from what comes back. Until `posts#index` answers that address with JSON, the page
says so.

## Catching up

`code-along-complete/` has the finished files from each code-along, at the same paths they
have in the app. See its README.

## The data

`scripts/create_data.rb` creates the rows. Change it and run it again any time:

    bin/rails runner scripts/create_data.rb

It deletes the companies, contacts, posts and users first, so it always ends with exactly the
rows in the file. `bin/rails runner scripts/show_data.rb` prints every table in the terminal,
and `/data` shows them in the browser.

The tables:

- `users`: `first_name`, `last_name`, `email`, `password` (a bcrypt hash), `password_digest` (unused)
- `posts`: `author`, `body`, `image`, `user_id`
- `companies`: `name`, `city`, `state`, `url`
- `contacts`: `first_name`, `last_name`, `email`, `phone_number`, `company_id`

## Working with an agent

`AGENTS.md` tells your agent how work happens here: one test per sentence of a definition of
done, the pattern, the commands. The code rules it points at are in `docs/code-style.md`.
Start yours with its command (`claude`, `codex` or `agy`) and sign in when it asks. Every
conversation with your agent here is copied into `agent-log/`; leave that folder alone.
