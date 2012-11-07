require 'factory_girl'

# A wrapper for FactoryGirl that caches the build, build_list, build_stubbed, create, and create_list methods using
# the method (as symbol) and arguments as the key for the cache, with the only wierdness being that if the second
# argument is a symbol, it removes that from the arguments before calling FactoryGirl with the arguments and block,
# such that it can use different caches for different associations.
module FactoryGirlCache
  class << self
    attr_accessor :factory_girl_cache

    def method_missing(m, *args, &block)
      if [:build, :build_list, :build_stubbed, :create, :create_list].include?(m)
        keys = args.dup
        args.delete_at(1) if args.size > 1 && args[1].is_a?(Symbol)
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
