---
layout: page
title: Latest posts
---

{% for post in site.posts limit: 3 %}
  <div class="post-excerpt">
    <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
    <small>{{ post.date | date_to_long_string }}</small> 
    <div class="inner-content">
      {{ post.content | excerpt: post.url, post.title }}
    </div>
  </div>

  {% if forloop.last != true %}
  <hr>
  {% endif %}
{% endfor %}