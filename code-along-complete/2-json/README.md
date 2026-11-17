# 2. The same posts, as data

`posts#index` answers two ways. `/posts` is the feed, a page for a person. `/posts.json` is the
same rows as JSON, data for another program: a page that draws the feed itself
(`public/spa/index.html`, at `/spa/index.html`), a phone app, or an agent.

The address decides which. `resources("posts")` already accepts a format at the end of any path,
and Rails puts it in `params["format"]`. Nothing else changed: same route, same query, a
different view. Whatever is in the table goes out in the JSON, every column, so deciding what an
API shows is the same decision as deciding what a page shows.
