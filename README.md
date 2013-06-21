BACKGROUND
==========

This app is designed to be a replacement for the existing wwwjdic website.
The original aim was for it to be a drop-in replacement although since building it
some usability enhancements have been considered.

The basic gist of the proposed changes is to use more client side javascript for a more
responsive user experience and try to remove a little of the visual clutter from the page
to aid comprehension and ease of use of the information.

The technology itself is a complete rewrite of the existing CGI scripts and uses
[Ruby](http://tryruby.org/) as the scripting langauge with the lightweight web framework
[sinatra](http://www.sinatrarb.com/)
and [Redis](http://redis.io) as the data storage.

The existing version of the site uses custom data storage well suited to the task of being
responsive and speedy, and the Redis implementation aims to retain some of that efficiency and
speed but improve maintainability of the source code. It should prove to be faster and
more scalable than traditional SQL based data storage. Because it is a dictionary and mostly
reads rather than writes then it is particularly suited to a key/value type datastore.


Additional data structure
-------------------------

I've also included a Trie data structure which is useful for autocomplete suggestions.
That was implemented by reading and reworking the following snippet:

[redis-implementing-auto-complete-or-how-to-build-trie](http://nosql.mypopescu.com/post/1123347183/redis-implementing-auto-complete-or-how-to-build-trie)


PREREQUISITES
=============

wwwjdic requires Ruby 1.9.2 and Redis.
The recommended way to install Ruby is through [rvm](http://beginrescueend.com/)

[Redis](http://redis.io/) can be installed on the mac with home brew.
[Git](http://git-scm.com/) is a dependency of RVM

```bash

#rvm
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)

#redis
brew install redis

#Ruby 1.9.2
rvm install 1.9.2
rvm use 1.9.2-p290 #use ruby 1.9.2 in this shell
rvm default 1.9.2-p290 #default to using ruby 1.9.2

```

SETUP
-----

Most of the app's prerequisites should be handled by [Bundler](http://gembundler.com).

```bash
#download the project itself if you've not already
git clone https://markburns@github.com/markburns/wwwjdic.git

#install bundler
gem install bundler

#install this project's dependencies
cd <root of project>

bundle install
```

Get setup quickly
-----------------

To try the app out without building all the indexes yourself:
you can use the existing dump of data and replacing your existing
redis storage with the bundled one:

```bash
redis-server
#Then hit ^\ to detach

lsof | grep redis-server
#determine the location of the data files

#sample output from my machine:
lsof | grep redis                         dtach     17159 mark    5u    unix 0xffffff801f753130        0t0          /tmp/redis.dtach
redis-ser 17160 mark  cwd      DIR               14,2        102   838055 /usr/local/var/db/redis
redis-ser 17160 mark  txt      REG               14,2     273564   838060 /usr/local/Cellar/redis/2.2.11/bin/redis-server
redis-ser 17160 mark  txt      REG               14,2     599232  8805391 /usr/lib/dyld
redis-ser 17160 mark  txt      REG               14,2  288940032  9310959 /private/var/db/dyld/dyld_shared_cache_x86_64
redis-ser 17160 mark    0u     CHR               16,1 0t12540059      815 /dev/ttys001
redis-ser 17160 mark    1u     CHR               16,1 0t12540059      815 /dev/ttys001
redis-ser 17160 mark    2u     CHR               16,1 0t12540059      815 /dev/ttys001
redis-ser 17160 mark    3r     CHR                3,2        0t0      306 /dev/null
redis-ser 17160 mark    4w     CHR                3,2        0t0      306 /dev/null
redis-ser 17160 mark    5u  KQUEUE                                        count=0, state=0x2
redis-ser 17160 mark    6u    IPv4 0xffffff8028d5ede0        0t0      TCP *:6379 (LISTEN)
redis-ser 17160 mark   22r     REG               14,2     126648  8818585 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/Resources/tokruleLE.data
redis-ser 17160 mark   23r     REG               14,2    5151552  8831079 /usr/share/langid/langid.inv
```

After looking in /usr/local/var/db/redis
I found dump.rdb

Assuming you are not already running redis you can stop the server

```
redis-cli
>SHUTDOWN
>exit

```

And replace that file with the bundled file in db/dump.rdb within this project

Included rakefile
-----------------
I've not tried out the rake scripts on any other machine, but you can also try a manual full import.
This took about 20 minutes on my new MacBook Pro so it probably needs improving.

There are also tasks for starting, stopping and restarting redis.
There's also 2 small files within spec/fixtures/ that can be used for quickly trying out
rebuilding the db.


```
rake db:rebuild[spec/fixtures/edict_small]
```

Tests
=====
Although this project has been a lot of me experimenting and learning Redis and getting more
familiar with Sinatra, the project has mostly followed a TDD approach and as such it should help
you if you run the tests to ascertain that everything is setup correctly.

At the moment the same (namespaced) redis db is used
for tests and development so you may want to set the environment variable
SINATRA_ENVIRONMENT before running tests. Otherwise you will delete all the indexed data and
need to copy it across again or rebuild it.

e.g.

```bash
SET SINATRA_ENVIRONMENT=test
bundle exec rspec spec/         #executes all the unit tests
bundle exec cucumber features   #executes all the behavioural integration tests
```


TODO
====

* Speedup and verify import process

* Get word search page working correctly and iron out encoding issues
  * Autocomplete
    * Improve appearance
    * Navigatable entries in drop down
    * Google style completion of text input field with first entry
  * Improve display of search options
  * MP3 playback
    * Get URLs working
    * Styling of report issue button
  * Example sentences
    * Decide on indexes
    * Create import process
    * Display of sentences (background loading?)


* HTTP caching settings - don't think sinatra is caching anything at the moment

* Improve appearance of js suggestions

* Start features for other pages:
  * Text Glossing
  * Kanji Lookup
  * Multi-Radical Kanji
  * User Guide
  * Dictionaries
  * Example Search
  * Enter New Entry
  * New Examples
  * Customize
  * Dictionary Codes
  * Donations

Performance benchmarks
----------------------

* As part of the test suite write some benchmarks that give an idea of current performance of the application.
These can even be used as failing tests if the new implementation isn't within an acceptable performance
level.

Load testing
------------

* Again it would be better if this can be tested against a local copy rather than the live site, but
maybe discuss with Jim about what kind of load-testing can be done against the real site if needs be.
