require 'factory_girl'

# A wrapper for FactoryGirl that caches the build, build_list, build_stubbed, create, and create_list methods using
# the method (as symbol) and arguments as the key for the cache. You can send in a :cached_as option and it will
# use that in place of the factory name/1st argument in the key of the cache.
module FactoryGirlCache
  class << self
    attr_accessor :factory_girl_cache

    def method_missing(m, *args, &block)
      if [:build, :build_list, :build_stubbed, :create, :create_list].include?(m)
        keys = args.dup
        options = args.last
        cached_as = options.is_a?(Hash) ? options.remove(:cached_as) : nil
        keys[0] = cached_as if !(cached_as.nil?) && keys.size > 0
        @factory_girl_cache ||= {}
        @factory_girl_cache[[m, *keys]] ||= FactoryGirl.__send__(m, *args, &block)
      else
        FactoryGirl.__send__(m, *args, &block)
      end
    end

    def clear
      @factory_girl_cache = {}
    end
  end
end
