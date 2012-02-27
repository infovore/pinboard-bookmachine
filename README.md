Bookmachine
===========

Bookmachine takes your Pinboard links and makes paperback books of them: one
6"x9" book a year.

Installation
------------

Bookmachine is a Sinatra app. Check out the code and then run

    bundle install

to set up all dependencies. You'll need Ruby/Bundler, obviously.

You'll need to create the SQLite database, next:

    rake db:migrate

(Note that you might need to prefix all rake commands, and rackup, with `bundle
exec`. Because bundler, alas.)

You will also need PrinceXML. Get that from http://www.princexml.com/download/ and install
the free version as per instructions. "prince" should be in your path before
you begin to publish books.

Usage
-----

Bookmachine has two components: a series of rake tasks, and a Sinatra webapp.

* First, place the output from `https://api.pinboard.in/v1/posts/all` into
  `data/pinboard_all.xml` . You'll need to authenticate via HTTP Basic.
* Then run `rake`. This will ingest all your links into a database.
* Now run `rackup`. This will start a Sinatra app on port 9292.
* If you visit localhost:9292 in a browser, you'll see all the books
  Bookmachine is going to make. Click on one to look at it in your browser.
  Note that the contents and index won't have page numbers - those will be
  added by PrinceXML later.
* With the webapp running, run "rake publish:all" from the shell to make PDFs
  of all years. Alternatively, to make a single year, run "rake publish:year
  YEAR=199" (for example).

Modification
------------

If you want to play with the format of the app, print.scss and application.scss
are the SASS stylesheets that define how books look. There's lots of
Prince-specific formatting in there. (Why are they two sheets? I forget;
I think application.scss was what I wrote on top of somebody else's print.scss.
It's a bit scrappy).

Covers
------

Covers are left as an exercise to the reader. I uploaded PNGs designed
according to the dimensions Lulu gave me; you might just want to use Lulu's
cover editor.

Printing
--------

I used lulu.com to print my books; the PDFs are set up for the "American Trade
Paperback" format. Other printers are available.
