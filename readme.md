# andreehansson.se&mdash;a jekyll website
This is my personal website created with jekyll and a few other tools. It's very hacky at the moment due to me being new to Ruby, jekyll, all the tools and so on.

To get this running you'll need:

* jekyll
* jammit
* optipng
* compass

cd into the repo dir, copy `_config.yml.default` to `_config.yml` and edit it. Then run `jekyll --auto --server`. Open up another terminal and go to the same dir, run `compass watch assets/` and visit `http://localhost:4000/`

Default `rake` will run all tasks, which will build website, compile SASS, concatenate and minify and deploy (or crash if you haven't set rsync up in config). Look in `Rakefile` for the individual tasks.

You're very welcome to fork/fix/send an issue!