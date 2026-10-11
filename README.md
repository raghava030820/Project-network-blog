# Network Blog

A clean, no-fuss blogging setup: write posts in a visual editor in your browser,
and the site rebuilds and publishes itself. No need to touch Hugo, Markdown
syntax, or the command line to publish.

## At a glance

| | |
|---|---|
| **Live site** | https://raghava030820.github.io/Project-network-blog/ |
| **Content editor (CMS)** | https://raghava030820.github.io/Project-network-blog/admin/ |
| **Repository** | https://github.com/raghava030820/Project-network-blog |
| **Built with** | [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme |
| **Editor** | [Sveltia CMS](https://sveltiacms.app/) (visual, browser-based) |
| **Hosting** | GitHub Pages (deployed by GitHub Actions) |

## How it works

```
  You write in the browser            GitHub                  GitHub Pages
 ┌───────────────────────┐      ┌──────────────┐      ┌───────────────────────┐
 │  Open the CMS (/admin) │      │              │      │                       │
 │  Write / edit a post   │─────▶│  Commit to   │─────▶│  Action builds Hugo   │
 │  Press "Publish"       │      │  main branch │      │  and deploys the site │
 └───────────────────────┘      └──────────────┘      └───────────────────────┘
        (browser)                 (storage)              (~1 minute, automatic)
```

The CMS is just a friendlier front end for plain Markdown files. When you press
**Publish**, it commits a Markdown file to this repository. GitHub Actions then
runs Hugo to turn that Markdown into HTML and publishes it to GitHub Pages.

You never edit Hugo config, run a build, or write front matter by hand.

## Writing a post (the everyday workflow)

1. Go to the CMS: **https://raghava030820.github.io/Project-network-blog/admin/**
2. Sign in (see [Signing in](#signing-in) below — first time only).
3. Click **Posts → New Post**.
4. Fill in the fields:
   - **Title** — required.
   - **Date** — defaults to today.
   - **Draft** — leave checked while writing; **uncheck it to publish**.
   - **Categories / Tags** — optional, used for grouping.
   - **Summary** — optional one-line description (used in lists).
   - **Cover image** — optional; upload an image.
   - **Body** — the post itself. Use the toolbar for **bold**, links, lists,
     code blocks, tables, and images. Drag images straight into the editor.
5. Click **Save**. This commits the post as a **draft**.
6. When ready, uncheck **Draft** and click **Save** again.

After saving, GitHub Actions takes **about 1 minute** to build and publish. Then
refresh the live site (hard refresh: `Cmd+Shift+R`).

> **Tip:** the CMS writes your post to `content/posts/<slug>/index.md` and stores
> any uploaded images next to it in `images/`. You don't need to manage paths.

### Drafts vs published

- **Draft checked** → saved to the repo, but **not visible** on the live site.
- **Draft unchecked** → visible on the live site after the next build (~1 min).

### Signing in

The CMS uses a GitHub **personal access token (PAT)** for login:

1. On the CMS login screen, click **Sign in with Token**.
2. Create a **fine-grained** token at
   https://github.com/settings/personal-access-tokens/new
   - **Repository access:** only `Project-network-blog`
   - **Permissions:** `Contents → Read and write`
   - **Expiration:** 90 days (regenerate when it lapses)
3. Paste the token into the prompt. It is stored in your browser and reused
   next time on that device.

The token is only sent to GitHub's API and is never written into the repository.
Treat it like a password: don't share it, and don't sign in on shared computers.
Revoke it any time at https://github.com/settings/tokens.

## Local development (optional)

You do **not** need this to blog. It's only for changing the theme, layout, or
site configuration, or previewing locally before publishing.

**Prerequisites:** [Hugo (extended)](https://gohugo.io/installation/) and Git.

```bash
# Get the latest content (the CMS commits directly to GitHub)
git pull

# Start a live-preview server at http://localhost:1313/project-network-blog/
hugo server -D     # -D includes drafts

# Build the site into ./public (not needed for normal publishing)
hugo --gc --minify
```

You can also scaffold a post from the terminal:

```bash
./scripts/new-post.sh "My Post Title"
```

> **Important:** the CMS commits to `main` on GitHub. Always `git pull` before
> making local changes, and push your changes when done, so the two don't drift.

## Project structure

```
.
├── content/
│   ├── posts/                 # all blog posts live here
│   │   ├── hello-world.md
│   │   ├── network-basics/    # a post "bundle": index.md + its images
│   │   │   ├── index.md
│   │   │   └── *.svg
│   │   └── <your-post>/
│   │       ├── index.md       # the post (written by the CMS)
│   │       └── images/        # images uploaded for this post
│   └── search.md              # search page
├── static/
│   └── admin/                 # the CMS itself (config.yml + index.html)
├── themes/PaperMod/           # theme (git submodule)
├── archetypes/                # template used by `hugo new`
├── scripts/new-post.sh        # local post scaffolding helper
├── assets/                    # custom CSS overrides
├── hugo.toml                  # site settings (title, menu, params)
└── .github/workflows/deploy.yml  # build + deploy to GitHub Pages
```

## Deployment

Every push to `main` triggers **`.github/workflows/deploy.yml`**, which:

1. Installs Hugo (extended) and Dart Sass.
2. Checks out the repo **including the theme submodule**.
3. Runs `hugo --gc --minify`.
4. Uploads the generated `public/` folder and deploys it to GitHub Pages.

You can watch builds under the repo's **Actions** tab. No manual deploy step is
ever required.

## Customizing

- **Site title, description, author, menus, feature toggles** → `hugo.toml`
- **Custom CSS** → `assets/css/extended/custom.css`
- **Which fields appear in the editor** → `static/admin/config.yml`

## Troubleshooting

- **My post isn't live yet.** Builds take ~30–70 seconds. Check the **Actions**
  tab; a green check means it deployed. Then hard-refresh the page.
- **A post isn't showing at all.** Make sure **Draft** is unchecked in the CMS.
  Hugo does not render drafts on the published site.
- **The CMS won't sign in.** The token likely expired or lacks write access.
  Create a new fine-grained token with `Contents → Read and write`.
- **`hugo` fails locally about the theme.** The theme is a git submodule; run
  `git submodule update --init --recursive`.
- **Local and remote disagree.** The CMS edits `main` directly — run
  `git pull` before local work.
