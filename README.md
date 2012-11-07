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

Even better, in RSpec you can clear cache after every test by adding this to `spec/spec_helper.rb`:

    Spec::Runner.configure do |config|
      config.after(:each) do
        FactoryGirlCache.clear
      end
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

Because it will use the method name and all arguments for the cache key, but will look for and remove the option `:cached_as` and used that instead of the factory name in the cache key.

For example:

    FactoryGirlCache.create(:post, cached_as: :great_post) # will create
    FactoryGirlCache.create(:post, cached_as: :great_post) # will return post from cache
    FactoryGirlCache.create(:post, cached_as: :bad_post) # will create
    FactoryGirlCache.create_list(:post, 2, cached_as: :great_posts) # will create list of 2
    FactoryGirlCache.create_list(:post, 2, cached_as: :bad_posts) # will create list of 2
    FactoryGirlCache.create_list(:post, 2, cached_as: :bad_posts) # will return list of 2 from cache
    FactoryGirlCache.build(:post, cached_as: :great_post) # will build
    FactoryGirlCache.build(:post, cached_as: :great_post) # will return post from cache
    FactoryGirlCache.build(:post, cached_as: :bad_post) # will build
    FactoryGirlCache.build_list(:post, 2, cached_as: :great_posts) # will build list of 2
    FactoryGirlCache.build_list(:post, 2, cached_as: :bad_posts) # will build list of 2
    FactoryGirlCache.build_list(:post, 2, cached_as: :bad_posts) # will return list of 2 from cache
    FactoryGirlCache.build_stubbed(:post, cached_as: :great_post) # will build stubbed
    FactoryGirlCache.build_stubbed(:post, cached_as: :great_post) # will return post from cache
    FactoryGirlCache.build_stubbed(:post, cached_as: :bad_post) # will build stubbed

#### Completely Override Cache Key

If the objects are equivalent, you can do this:

    FactoryGirlCache.create(:bar, cache_key: :bird) # will create
    FactoryGirlCache.create(:foo, cached_as: :bird) # will return bar from cache

### License

Copyright (c) 2012 Gary S. Weaver, released under the [MIT license][lic].

[factory_girl]: https://github.com/thoughtbot/factory_girl
[lic]: http://github.com/garysweaver/factory_girl-cache/blob/master/LICENSE
