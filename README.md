# Url-Shortner

A Simple Ruby on Rails Project for conversion of Long Url into short and vice versa.

A Simple web application UI that provides a bunch of services.
Redis is used for caching and Sidekiq for doing asynchronous jobs.
Elasticsearch is used for seaching long url as well as short url. 
You can create domain for urls before converting them into short url.


In addition to Web UI, api for coversion is also provided.
You can see the documentation for more details inside doc folder.

* How to set Up.
	- git clone git@github.com:vgswn/Url_Shortner.git
	- cd Url_Shortner
	- bundle install
	- bundle update
	- rake db:drop
	- rake db:create
	- rake db:migrate
	- type 'rails s' for starting rails server
	- open another terminal with same directory and start redis server by typing 'redis-server'
	- open another terminal with same directory and start sidekiq server by typing 'bundle exec sidekiq'

* You can open 'localhost:3000' for web ui 
* For api related queries refer to the documentation provided inside doc folder.


