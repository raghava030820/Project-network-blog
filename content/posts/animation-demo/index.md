---
title: "Animation Demo"
date: 2026-11-10
draft: true
categories: ["Guides"]
tags: ["animation", "svg"]
summary: "Example post showing how to embed an animated packet-flow diagram (and video) in Hugo."
---

This post demonstrates embedding motion in a Hugo post. Delete it once you've tried it.

## Animated packet flow (SVG)

The diagram below is a plain animated SVG stored in this post's `images/` folder.
It works with normal Markdown — no shortcode, no JavaScript:

![Packet flow from client to server](images/packet-flow.svg)

## Video (optional)

For longer animations, render a WebM/MP4 and use the `video` shortcode:

```text
{{</* video src="images/packet-flow.webm" */>}}
```

The shortcode looks for the file in the post bundle and renders a looping,
muted, autoplaying `<video>`. Replace `packet-flow.webm` with your own file.
