FactoryGirl Cache
=====

A wrapper for FactoryGirl that caches the build, build_list, build_stubbed, create, and create_list methods using the method (as symbol) and arguments as the key for the cache, with the only wierdness being that if the second argument is a symbol, it removes that from the arguments before calling FactoryGirl with the arguments and block, such that it can use different caches for different associations.

It does this with method_missing on the FactoryGirlCache module calling via `__send__`, so anything that FactoryGirl (literally, the module) can do, FactoryGirlCache should be able to do.

Just as an example, instead of:

    FactoryGirl.create(:post)
    FactoryGirl.create_list(:post, 2)
    FactoryGirl.build(:post)
    FactoryGirl.build_list(:post, 2)
    FactoryGirl.build_stubbed(:post)

You can use these to ensure that create, create_list, build, build_list, and build_stubbed return the same result instance(s) everytime after the first call (before the cache is cleared):

    FactoryGirlCache.create(:post)
    FactoryGirlCache.create_list(:post, 2)
    FactoryGirlCache.build(:post)
    FactoryGirlCache.build_list(:post, 2)
    FactoryGirlCache.build_stubbed(:post)

To clear the cache:

    FactoryGirlCache.clear

This may seem completely odd, e.g. creating something would imply really creating a new instance, as would building. And you'll get the same id back. Why would you want to do that?

Originally, the idea was that this could be used to avoid circular references, but there are other complexities in factory interdependencies that keep the cache alone from being a silver bullet for those issues. However, for some cases it could still significantly speed up accessing factory created instances, if you are careful.

This gem should not affect FactoryGirl itself. It just provides an alternate way to use FactoryGirl that makes it behave a bit differently.

Please understand what you are doing by using this. Handle it carefully and don't shoot yourself with it!

### Installation

Add to gemfile:

    gem 'factory_girl-cache'

Then:

    bundle install

### Usage

#### Require

You may need to add this to the top of the test or factories.rb or wherever you are going to use it:

    require 'factory_girl-cache'

#### Be Sure to Clear Cache After Every Use

In your tests, be sure that the cache is cleared after anything that uses it is done, otherwise it probably will eventually pollute other tests if you are not careful!

With Rails tests:

    def teardown
      FactoryGirlCache.clear
      # ...
    end

With RSpec:

    after(:each) do
      FactoryGirlCache.clear
      # ...
    end

You can also clear cache during your tests, if it makes sense.

#### Use That Cache

If you have a post factory, then the first time you do:

    FactoryGirlCache.create(:post)

It will call:

    FactoryGirl.create(:post)

The second time you call it, it will just return the same instance it did before (not dup'd or anything and the id or primary key will be the same):

    FactoryGirlCache.create(:post)

If you use a different method, that has a different cache, so:

    FactoryGirlCache.create_list(:post, 2)

Will create two more posts. But if you call it again that will return those same two posts:

    FactoryGirlCache.create_list(:post, 2)

More examples:

    FactoryGirlCache.create(:post)
    FactoryGirlCache.create_list(:post, 2)
    FactoryGirlCache.build(:post)
    FactoryGirlCache.build_list(:post, 2)
    FactoryGirlCache.build_stubbed(:post)

#### Store Results From Same Factory for Two Different Associations Separately

Because it will use the method name and all arguments (after dup-ing) for the cache key, but will remove the second argument if ones exists after using it as the cache key, you can differentiate results from the same factory/store them in different caches.

Examples:

    FactoryGirlCache.create(:post, :great_post) # will create
    FactoryGirlCache.create(:post, :great_post) # will return post from cache
    FactoryGirlCache.create(:post, :bad_post) # will create
    FactoryGirlCache.create_list(:post, :great_posts, 2) # will create list of 2
    FactoryGirlCache.create_list(:post, :bad_posts, 2) # will create list of 2
    FactoryGirlCache.create_list(:post, :bad_posts, 2) # will return list of 2 from cache
    FactoryGirlCache.build(:post, :great_post) # will build
    FactoryGirlCache.build(:post, :great_post) # will return post from cache
    FactoryGirlCache.build(:post, :bad_post) # will build
    FactoryGirlCache.build_list(:post, :great_posts, 2) # will build list of 2
    FactoryGirlCache.build_list(:post, :bad_posts, 2) # will build list of 2
    FactoryGirlCache.build_list(:post, :bad_posts, 2) # will return list of 2 from cache
    FactoryGirlCache.build_stubbed(:post, :great_post) # will build stubbed
    FactoryGirlCache.build_stubbed(:post, :great_post) # will return post from cache
    FactoryGirlCache.build_stubbed(:post, :bad_post) # will build stubbed

### License

Copyright (c) 2012 Gary S. Weaver, released under the [MIT license][lic].

[factory_girl]: https://github.com/thoughtbot/factory_girl
[lic]: http://github.com/garysweaver/factory_girl-cache/blob/master/LICENSE
