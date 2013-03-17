---
title: Introducing mqa.js
layout: post
category : articles
tags : [javascript, css, media query]
description: Introducing mqa.js—a small library for easing the use of media queries in JavaScript.
---

It has been almost a year since I launched this website. Because of various reasons I haven't really had time to write any (it surely isn't because I've had lack of stuff to write about!). But here's finally a new, short article and I'm happy I finally wrote a new one. Let me introduce [mqa.js](https://github.com/peol/mqa.js) (meqa.js)—a small library for easing the use of media queries in JavaScript.

<!--more-->

##What does it do?
`mqa.js` helps you leveraging the power of media queries in JavaScript. There's only a handful of maintained libraries out there in regards of media queries, and none of them did exactly what I wanted them to—minimize the duplication of media queries.

Currently, if you want to do something in JavaScript when a media query triggers (or "de-triggers"), you need to use the exact same media query you have in your CSS file, in your JavaScript file (when using the [window.matchMedia](https://developer.mozilla.org/en-US/docs/DOM/window.matchMedia) API/libraries).

Consider this media query in your CSS file:

{% highlight css %}
@media all and (orientation: landscape) {
  .foo { color: blue; }
}
{% endhighlight %}

To use it in JavaScript, you'd need to use `window.matchMedia`:

{% highlight javascript %}
var mql = matchMedia("(orientation: landscape)");
if (mql.matches) {
  // do something when the media is active
}
{% endhighlight %}

This is, at least from my point of view, not really maintainable in the long run. As soon as I change something in my CSS query, I need to update my JavaScript accordingly. This is where `mqa.js` comes in.

##Using it
`mqa.js` supports a custom alias syntax, a class spoof, to enable you to label your media queries. It automatically parses your included style sheets for any aliased media queries, and exposes them as events:

CSS:

{% highlight css %}
@media all and (orientation: landscape) {
  #-mqa-alias-myLandscapeMQ {}
  .foo { color: blue; }
}
{% endhighlight %}

JavaScript:

{% highlight javascript %}
mqa.on("myLandscapeMQ", function(active) {
  // this handler gets triggered when the media query
  // is either activated or deactivated
});
{% endhighlight %}

`mqa.js` also supports adding media queries programmatically, so that you can work with them just like any parsed media query from your CSS files:

{% highlight javascript %}
mqa.add("maxwidth", "(max-width: 600px)");
mqa.on("maxwidth", function(active) {
  // do stuff
});
{% endhighlight %}

##Browser support
As of now, I've tried in all major browsers:
* Safari 6 (native)
* Firefox 19 (native)
* Chrome 24 (native)
* Internet Explorer 9 (with polyfill)
* Internet Explorer 10 (native)
* iOS6 (native)

To see the full documentation, demo and source code just head over to my [GitHub page for `mqa.js`](https://github.com/peol/mqa.js).
