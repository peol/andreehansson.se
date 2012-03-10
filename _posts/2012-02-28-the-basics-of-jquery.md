---
title: The Basics of jQuery
layout: post
category : articles
tags : [jquery, intro, javascript]
description: An introduction to jQuery, going through the basics and helping you understand the cornerstones.
---

So, a while back I had an internal presentation at work about this topic. A few good friends in the community took a look at my slides, and they thought it would make a nice blog post because _"there can't be too many good posts about jQuery introduction and best-practices."_ Whether this post is going to be good or not, is up to you but I'll try to outline what jQuery is, and how you can start working with it.

For most of you, this will just be a re-cap and probably not provide much new information but can perhaps serve as a reference post if you ever need one. I will expect some basic knowledge about JavaScript but you do not have to be an expert, heck, you don't even need to have used jQuery before&mdash;but you should know terms like [object literals](https://developer.mozilla.org/en/Core_JavaScript_1.5_Guide/Core_Language_Features#Object_literals), [anonymous functions](https://developer.mozilla.org/en/JavaScript/Reference/Functions_and_function_scope), and what [DOM](http://en.wikipedia.org/wiki/Document_Object_Model) and [CSS](https://developer.mozilla.org/en/CSS) are.

##What is jQuery?
jQuery is a client-side JavaScript library that abstracts away browsers' different implementations into an easy-to-use API.
What jQuery does best is to interact with the DOM (add, modify, remove elements on your page), do AJAX requests, create effects (animations) and so forth. It does _not_ provide an application framework, it's merely a tool amongst others that should be used what it's meant to be used for. However, there's a plethora of plugins due to a thriving community, and there's pretty much a plugin for anything you can think of.

Recently, it also set a new usage record with being used on *54 per cent* of Alexa's top 17,000 most visited websites, while Flash was "only" at 47 per cent.

Before we continue, I'd like to quote [@johanbrook](https://twitter.com/#!/johanbrook/statuses/157838820249845760) who, when I asked what I should mention to people that might not have used jQuery before, said: _Don't go to bed with it_. That said, jQuery is still the best library for DOM manipulation, AJAX and effects and in this article you'll find out why.

##How do I use jQuery?
First off, you should learn some basics. jQuery, like many other libraries, uses the global `$` variable as a shortcut. Basically, `window.jQuery === window.$` (and therefore, `$("div")` and `jQuery("div")` are identical. You can use whichever you prefer, but `$` is shorter and neater, it also provides better readability since it's easier to spot than `jQuery`, which is a more conventional name for a variable (being plain text).
There are two parts to jQuery. There are methods which run on collections and rely on `$.fn` (a shortcut for `$.prototype`). There are then utility methods which run directly on `$`&mdash;for example [`$.data()`](http://api.jquery.com/jQuery.data/) and [`$.ajax()`](http://api.jquery.com/jQuery.ajax/), which don't require a collection to work.

###Using selectors and instance methods
jQuery sports a CSS3 selector engine called Sizzle, which means that more or less all selectors you use in your stylesheet can be applied to the DOM to query for elements matching them. Consider the following markup:

{% highlight html %}
<div id="foo">
    <div class="bar"></div>
    <div class="bar"></div>
</div>

<div id="baz"></div>
{% endhighlight %}

In CSS, to select the `div` element with id `foo`, you'd use `#foo {}`. That's exactly what you do with jQuery as well. We use the `$` shortcut we talked about earlier, and use it as a function, which will query the DOM and return a new jQuery instance, allowing us to operate on said collection: `$("#foo")`.

So, let's try to modify `#foo`, and give it a background.

{% highlight javascript %}
$("#foo").css("background-color", "red");
{% endhighlight %}

Here, we simply used the [`$.fn.css()`](http://api.jquery.com/css/) method to set the background to `red`. But what about if I wanted to do more? Maybe I would like to set the `font-weight` to `bold`? This is where object literals come in handy, most of jQuery's methods allow you to send in an object containing several values instead of repeating method calls:
 
{% highlight javascript %}
$("#foo").css("background-color", "red");
$("#foo").css("font-weight", "bold");

// becomes:

$("#foo").css({
    "background-color": "red",
    "font-weight": "bold"
});
{% endhighlight %}

Now, wasn't that easy? As I said, you can use this on several methods like [`$.fn.attr()`](http://api.jquery.com/attr/), [`$.fn.prop()`](http://api.jquery.com/prop/) and so on.

Another thing to note here is that while I in my example used repeated `$("#foo")`, you shouldn't. It's considered bad practice since you will be creating a new jQuery instance each time, and also query the DOM twice. Good practice states that you should always cache your collection whenever possible, if you're using it more than once. So instead of this:

{% highlight javascript %}
$(".bar").css("color", "blue");
// lots of code
$(".bar").appendTo("#baz");
{% endhighlight %}

we should cache `$(".bar")` in a variable, so we can re-use it later:

{% highlight javascript %}
var bars = $(".bar");
bars.css("color", "blue");
// lots of code
bars.appendTo("#baz");
{% endhighlight %}

Now we're entering one of jQuery's most powerful features, _chaining_. Let's imagine for a second that there was no `// lots of code` separating the two jQuery method calls.

{% highlight javascript %}
var bars = $(".bar");
bars.css("color", "blue");
bars.appendTo("#baz");
{% endhighlight %}

It works, it's readable, but we can do better. jQuery's methods, except for a select few, returns the jQuery-wrapped collection you operated on. This means we can chain method calls together, instead of having to repeat the collection/variable reference. This also means that we can skip the `var` statement in this example.

{% highlight javascript %}
$(".bar").css("color", "blue").appendTo("#baz");
{% endhighlight %}

You can go nuts with chaining, I've seen some mad chaining in my days and can be messy if you don't format it correctly. Sometimes, it's even better to use multiple variable references to ease readability for other developers. Consider this example:

{% highlight javascript %}
$("#foo").css("color", "red")
    .click(function(){ /* event handler */ })
    .mousedown(function(){ /* event handler */ })
    .mouseup(function(){ /* event handler */ })
    .attr("id", "my-new-id")
    .find(".child")
        .css("color", "blue")
        .mouseup(function(){ /*...*/ });
{% endhighlight %}


That's a lot of new information at once, I know, but if we ignore what the actual method calls do for now and look at how the indentation follows the flow of the actual code instead, we can see exactly were we're modifying our collection (`$.fn.find()`), and what we're doing after we modified it. It's just something you should keep in mind when you start chaining like a mad man&mdash;readability should always be a priority, someone will be maintaining your code and shouldn't be spending hours trying to figure out what is happening.

###Making sure the document is ready
One thing that I see several times a week in the #jQuery help channel on FreeNode, is people misunderstanding how the DOM works. The browser basically has to parse the entire markup you gave it and the DOM hierarchy before you can interact with it. This can be tricky, especially if you're using jQuery because it won't tell you when you, for example, try to change a background color on an element and the collection were empty. Querying the DOM before it's ready will leave you at risk for problems like these, where you see that you have an element with id `foo` in the document, but nothing happens when you run your code and you yell at jQuery because it's not working.

Enter [`$(document).ready()`](http://api.jquery.com/ready/), the one method you really need to know about. It's used like this:
 
{% highlight javascript %}
$(document).ready(function() {
    // everything in here will be run when the DOM is
    // ready to be interacted with
    $(".bar").css("color", "blue").appendTo("#baz");
});
{% endhighlight %}

You should **really** remember this, it's an easy mistake and we all do it every now and then.

##The most common methods
So, now that you are somewhat familiar with jQuery's power and syntax, you should feel more comfortable working with it. Let me introduce you to a few things that can help you along your way.

### [.find()](http://api.jquery.com/find/) and [.filter()](http://api.jquery.com/filter/)
Two of the most used methods that jQuery has to offer. They find elements inside other elements, and filter the collection, respectively.

{% highlight html %}
<div id="foo" class="parent">
    <div class="bar"></div>
    <div class="bar"></div>
</div>

<div id="baz" class="parent">
    <p class="bar"></p>
</div>
{% endhighlight %}

Let's say I wanted to find all `.bar` elements within all `.parent` elements…

{% highlight javascript %}
// this will give you a collection with all three .bar elements
$(".parent").find(".bar");

// this will give you a collection with one .bar element
$("#baz").find(".bar");
{% endhighlight %}

Really useful, isn't it? To accompany `.find()` we have `.filter()`, which doesn't dig into the elements you already have and look for others, it filters the elements you already have in your collection.

{% highlight javascript %}
// get all three .bar elements again, but filter out everything
// that isn't a `p` element, so we end up with just one element
$(".parent").find(".bar").filter("p");
{% endhighlight %}

###[.on()](http://api.jquery.com/on/) and [.off()](http://api.jquery.com/off/)
Previously [`.bind()`](http://api.jquery.com/bind/), [`.delegate()`](http://api.jquery.com/delegate/) and [`.live()`](http://api.jquery.com/live/), is used to bind events. The syntax is really easy:

{% highlight javascript %}
$("#foo").on("click", function(evt) {
    // do something when user clicks on the #foo element
});
{% endhighlight %}

There's also built-in support for event delegation, which is basically that you bind an event on an element you know won't change, instead of on elements that might. Let's go back to our markup again, the `#foo` element has two `.bar` elements in it. Instead of binding _two_ events and break future `.bar` elements to work without having to bind a third, fourth, and fifth event; we use delegation. The only thing different from the normal syntax in the code example above, is that we add a parameter in the middle between the event type and the event handler, and we originate the event from the parent, `#foo`, instead of binding it directly to the `.bar` elements.

{% highlight javascript %}
$("#foo").on("click", ".bar", function(evt) {
    // do something when user clicks on .bar elements,
    // existing and future ones alike
});
{% endhighlight %}

###[.ajax()](http://api.jquery.com/ajax/) and its helpers
While straight-up interaction with your webpage is nice, you often have a need to pull in data asynchronously so that your user doesn't constantly have to refresh your page. This is done using `$.ajax()`, or some of its helpers:

* [`$.get()`](http://api.jquery.com/jQuery.get/) - Gets data from an URL
* [`$.getJSON()`](http://api.jquery.com/jQuery.getJSON/) - Same as above, but automatically returns a JavaScript object with your data (instead of a string)
* [`$.post()`](http://api.jquery.com/jQuery.post/) - Submits data to an URL
* [`$.fn.load()`](http://api.jquery.com/load/) - Loads data from an URL into your jQuery collection

There are a few others, more obscure, that I'll let you look up if you [want to know](http://api.jquery.com/category/ajax/). First off, before we go into detail on the different helpers; they all use `$.ajax` behind the scenes, with predefined values. Everything you can do with the helpers, is possible (and _are_ done) with `$.ajax()`.

To simply retrieve data from your server, you need a few properties to send into `$.ajax()`:

{% highlight javascript %}
$.ajax({
    url: "/some/path/mydata.html",
    success: function(data) {
        // do something with `data` that you retrieved
        // from the server
    }
});
{% endhighlight %}

Introduced in jQuery 1.5, you can also do:

{% highlight javascript %}
$.ajax({
    url: "/some/path/mydata.html"
}).done(function(data) {
    // do something with `data` that you retrieved
    // from the server
});
{% endhighlight %}

How this works is a bit out of scope for this article, but for now, just imagine that it works exactly as the first example. I personally prefer the second example, because it doesn't clutter the AJAX, you can easily see what you're requesting, and how you do it, and what you do when the data has been retrieved.

That said, let's us look at how the helpers work. Remember, they all use `$.ajax()` in the background.

####$.get()
When you simply want to retrieve data, `$.get()` is your friend. The simplest usage looks like this:

{% highlight javascript %}
$.get("/some/path/mydata.html", function(data) {
    // do something with `data` that you retrieved
    // from the server
});
{% endhighlight %}

It does support more parameters, but I think you can see that for yourself should you ever need to use it on a more advanced level.

####$.post()
This one is super useful if you ever need to submit a form, for example. It does a lot of work for you so you don't have to repeat yourself every time you want to push data back to the server. Let's say you have this form on your webpage:

{% highlight html %}
<form method="post" action="/some/path/form.php" id="userform">
    <label for="username">Username:</label>
    <input id="username" name="username" />
    <label for="password">Password:</label>
    <input id="password" name="password" type="password" />
    <input type="submit" />
</form>
{% endhighlight %}

When the form is submitted, we want to use AJAX to send that data over to the server, instead of actually reloading the page and send the user to `form.php`. First off, we're going to bind the `submit` event on the form, and cancel that so the browser doesn't send the user to the `action` URL. Then we're going to serialize the form using [`$.fn.serialize()`](http://api.jquery.com/serialize/) into a data format that is recognizable by the server, and lastly, we send that data over.

{% highlight javascript %}
// cache our form
var userform = $("#userform");

// bind the `submit` event
userform.on("submit", function(evt) {
    // serialize the form
    var data = userform.serialize();

    // POST the data to the server using the form's action URL
    $.post(userform.attr("action"), data, function() {
        // Data sent, let's clear the form elements
        userform.find("input, select, textarea").val("");
    });

    // Make sure the browser doesn't send the user over
    // to the action URL
    evt.preventDefault();
});
{% endhighlight %}

It's quite a bit more advanced than the other examples, but when you understand this, you'll have a much better image of how you can use jQuery to do awesome things rather simple (especially compared to _vanilla_/normal JavaScript).

I think that's all for now, I hope you found this post somewhat useful and please let me know if you have any questions, I'm [@peolanha](http://twitter.com/peolanha) on twitter and `peol` on FreeNode (IRC). I'd also like to thank [Addy Osmani](http://twitter.com/addyosmani) who reviewed this article both linguistically and technically.
