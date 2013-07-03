SpreeBraspag
============

This gem integrates spree ecommerce with brazilian Braspag gateway.

Gem developed for [Via Lumina - Artigos Religiosos](http://www.vialumina.com.br/) by [Locomotiva.pro](http://locomotiva.pro/)


Installing
=======

First add SpreeBraspag to your store And install it.

    $ gem 'spree-braspag'
    $ rails generate braspag:install
    $ rails generate spree_braspag:install

Now edit 'config/braspag.yml' with your braspag keys.

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 Locomotiva.pro, released under the New BSD License
