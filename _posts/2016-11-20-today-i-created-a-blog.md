---
layout: post
title:  "Today I Created a Blog"
date:   2016-11-20 15:51:00 -0800
categories: jekyll update
---
I like to create things, and tell other people about the things that I create.  

Today I created a blog. 

I wanted a blog engine where I could write markdown and check it in to a git repo, so I googled "blog markdown git repo" and found a thing called [jekyll][jekyll-docs] that you can use with github pages to make a blog. 

This is what I did: 

1. Make a local blog in a directory using the [Jekyll Quickstart][jekyll-quickstart]
2. `git init`
3. Make a repo on github called `myusername.github.io`
4. Add the github repo as a remote and push

That's it!

It follows that "convention over configuration" thing that a lot of ruby projects do, so you make posts by putting markown files in the `_posts` directory and naming them with the convention `YYYY-MM-DD-title-of-post.md` and they magically show up on github pages after you push. 

I'm sure I might find limitations if I decide to start doing fancy stuff, but right now I'm digging the simplicity. 

[jekyll-quickstart]: https://jekyllrb.com/docs/quickstart
[jekyll-docs]: http://jekyllrb.com/docs/home
