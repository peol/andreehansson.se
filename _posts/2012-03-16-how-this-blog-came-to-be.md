---
title: How this blog came to be
layout: post
category : articles
tags : [blog, jekyll, sass, ruby, rake]
description: Explanation on the choices made when setting up this blog post. You'll learn how to set up your own blog running on Jekyll.
---

So, I've gotten quite a few questions regarding what platform this website is running on so I thought it was time to do the obligatory "what I used to create my blog" post. Whatever you do, there's almost always at least two options. In the case of choosing a blog platform, there's a plethora. I'll explain what I use and how you can use it too.

<!--more-->

##Jekyll

So, I chose [Jekyll](http://jekyllrb.com/) as my blog engine. It wasn't really a hard choice, since it's a static site generator I could easily have version control of my posts, there was no overhead with databases, no requirements for the web server and so forth. Basically, I could launch my website anywhere as long as it had a web server running. Also, people can contribute and fix my mistakes, which is great when you do a lot of posts on development-related topics where you're bound to make a few mistakes here and there.

But there's several flavors of Jekyll and I tried [Octopress](http://octopress.com/) first, which has gotten quite a few followers lately. It's easy to set up and has a lot of useful plugins/configuration out-of-the-box. But it had too much stuff for my liking, when I decided I wanted to start a blog I wanted it to be just that; no bloat, no distractions, just posts and maybe a small "About" somewhere... So I looked further and found [jekyll-bootstrap](http://jekyllbootstrap.com/), which had less stuff and great support for themes, which was a plus since I had never written a line of Ruby or set up Jekyll before. I had a beautiful blog running in mere minutes and that was what I initially used when I first launched. I think it went two and a half hours after choosing jekyll-bootstrap to having the blog launched, the only thing I did was minor changes to the [minimum-theme](https://github.com/studiomohawk/jekyll-theme-the_minimum) and added an "About" section.

But last week I started re-implementing the theme from scratch, using less mark-up and less (as in fewer lines of code, not the pre-processing language) CSS, just the necessary things to get everything running. But jekyll-bootstrap ended up just like Octopress, there was too much stuff that I didn't use, and having several themes installed made working with it kind of messy (that said, it's a great project and I think that it'll be awesome once it has matured and stream-lined the set up process and theming). So I moved to a plain Jekyll implementation, and that's where we're at now.

That said, it wasn't the only reason. I also wanted to learn more about how you use Jekyll and how you extend it. Also, I found it fun to work with and motivated me to continue working on my personal projects and articles, I've setup countless WordPress installations and it has become a quite boring task. Also, it's not a fun tool to work with for some reason, it's not very _developer-y_, if you know what I mean. It's made for users who are not very technically-focused and it didn't really speak to me.

##How to set up this website locally

If you want to try running an instance of this website, you need to install a few tools. I'm sorry to all Windows/linux users, this will be pretty focused on Mac OS since that's the only thing I work with at home.

###Ruby

Most of the dependencies of this project need Ruby, so we'll start with that. I used rvm to easily install Ruby and be able to keep several versions of Ruby installed at once (and switch between them if need be). Go into a terminal window and type (steps taken from [here](http://beginrescueend.com/rvm/install/)):

{% highlight bash %}
$ bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
{% endhighlight %}

{% highlight bash %}
$ bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
{% endhighlight %}

When the installation is completed, you need to either restart your terminal window or run `source ~/.bash_profile` to reload your environment variables. The next step is to lookup the dependencies and requirements of rvm:

{% highlight bash %}
$ rvm requirements
{% endhighlight %}

This will outline what you need to do before we actually install a Ruby version. When you have followed those guide lines, run:

{% highlight bash %}
$ rvm install 1.9.3
{% endhighlight %}

At the time of this post, 1.9.3 is the latest stable release of Ruby. You might need to look up the latest version.

###Jekyll, Compass and Jammit

When you have Ruby and gems installed, you should be able to simply type `sudo gem install jekyll`. We now have Jekyll installed for use.

Compass is a tool that compiles `.sass` and `.scss` files into plain `.css`. It also has a really useful watch command, that allows us to watch for changes in a folder and re-compile the CSS files whenever there's a change.

To install compass, all you need to do is `gem install compass`.

Jammit is a tool you can use to concatenate and minify your resources. I don't have any JavaScript on my site, but I do have a few CSS files. I run this tool after Compass has compiled the SASS files. I also use a plugin which parses its asset file when I run in a development environment so I don't have to run jammit every time I made a change.

To install jammit, run `gem install jammit`.

###optipng

I also added optipng, which optimizes all PNG files without losing any quality. This is however optional to use since it takes quite a while to run. I won't go through the process of how to install it, but if you use Homebrew (which is really useful), you can just run `brew install optipng`.

###Running the environment

When we have all the dependencies installed, we need to get the files from [github](https://github.com/peol/andreehansson.se). Either check out the repository with `git clone git@github.com:peol/andreehansson.se.git` or [download it](https://github.com/peol/andreehansson.se/zipball/master).

`cd` into the directory your cloned/extracted the files to. You need two terminals that both are `cd`:d into that directory.

run `jekyll --auto --server` in the first one, and `compass watch assets/` in the other. It should look something like this:
<img src="/assets/img/posts/terminals-running-jekyll-compass.png">

You should now be able to navigate to [http://localhost:4000/](http://localhost:4000/) and see the website, and whenever you make a change in either the posts or CSS, it'll be automatically re-generated/compiled so all you need to do is refresh the page.

##Deploying

As an additional thing, I wanted to learn more about Rakefiles. It's basically Makefiles for Ruby. I have defined a few different build targets (called tasks in Rake).

* `rake build`&mdash;Builds the website with Jekyll, outputed to `_site/`
* `rake generatecss`&mdash;Compile SASS files to CSS files
* `rake compressassets`&mdash;Concatenate och minify the assets (currently only CSS), outputed to `_site/assets/`
* `rake optimizepngs`&mdash;Runs `optipng` on all PNG files located in `assets/img/`, outputed to `_site/assets/img`
* `rake deploy`&mdash;Deploys to a remote server using rsync, the rsync parameters must be set in `_config.yml` or it'll fail miserably

If you run just `rake` it'll run all of these (in that order) except for optimizepngs, which took a good while to run so I got tired of it :-)

---

This is all for this post and I hope it made somewhat sense to you. If you have any problems or feedback, you can either tweet at me or comment below. You're also **very welcome** to send pull request on this [post over at github](https://github.com/peol/andreehansson.se/tree/master/_posts).