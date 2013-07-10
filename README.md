BACKGROUND
==========

This app is designed to be a replacement for the existing wwwjdic website.  The
original aim was for it to be a drop-in replacement although since building it
some usability enhancements have been considered.

The basic gist of the proposed changes is to make the site provide a RESTful
interface and use a bit of client side javascript for a more responsive user
experience and try to remove a little of the visual clutter from the page to
aid comprehension and ease of use of the information.

The technology itself is a complete rewrite of the existing CGI scripts and
uses [Ruby](http://tryruby.org/) as the scripting langauge with the lightweight
web framework [sinatra](http://www.sinatrarb.com/) and [Redis](http://redis.io)
as the data storage.

The existing version of the site uses custom data storage well suited to the
task of being responsive and speedy, and the Redis implementation aims to
retain some of that efficiency and speed but improve maintainability of the
source code. It should prove to be faster and more scalable than traditional
SQL based data storage. Because it is a dictionary and mostly reads rather than
writes then it is particularly suited to a key/value type datastore.



SETUP
=============
Ruby ( >2.0.0 to run the data import, 1.9 to run the server)
Use either RVM or rbenv:
  * [rvm](http://beginrescueend.com/)
  * [rbenv](https://github.com/sstephenson/rbenv)
  * [mecab](https://github.com/markburns/mecab)
  * [Redis](http://redis.io/) can be installed on the mac with home brew.
  * [Git](http://git-scm.com/) is a dependency of RVM

```bash
git clone https://markburns@github.com/markburns/wwwjdic.git
cd wwwjdic
gem install bundler
bundle install
```

DB Import
-----------------
I've not tried out the import scripts on any other machine.
It takes about 20 minutes on my new MacBook Pro so it probably needs improving.

There's also 2 small files within spec/fixtures/ that can be used for quickly trying out
rebuilding a small version of the db.

```
rake db:rebuild[spec/fixtures/edict_small]
```

Starting the server
___________________
```
bundle exec thin start

```

TODO
====

  See https://trello.com/board/wwwjdic-tng/51d8062f8c3f2021080002df
