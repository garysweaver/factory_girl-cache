require 'factory_girl'

class FactoryGirlCache

  @@create_cache = {}
  @@create_list_cache = {}
  @@build_cache = {}
  @@build_list_cache = {}
  @@build_stubbed_cache = {}

  def self.build(class_sym, assc_sym = nil)
    assc_sym ||= class_sym
    @@build_cache[[class_sym, assc_sym]] ||= FactoryGirl.build(class_sym)
  end

  def self.build_list(class_sym, assc_sym = nil, number = nil)
    number ||= assc_sym
    assc_sym ||= class_sym
    number = 0 unless number.is_a? Integer
    @@build_list_cache[[class_sym, assc_sym, number]] ||= FactoryGirl.build_list(class_sym, number)
  end

  def self.build_stubbed(class_sym, assc_sym = nil)
    assc_sym ||= class_sym
    @@build_stubbed_cache[[class_sym, assc_sym]] ||= FactoryGirl.build_stubbed(class_sym)
  end

  def self.create(class_sym, assc_sym = nil)
    assc_sym ||= class_sym
    @@create_cache[[class_sym, assc_sym]] ||= FactoryGirl.create(class_sym)
  end

  def self.create_list(class_sym, assc_sym = nil, number = nil)
    number ||= assc_sym
    assc_sym ||= class_sym
    number = 0 unless number.is_a? Integer
    @@create_list_cache[[class_sym, assc_sym, number]] ||= FactoryGirl.create_list(class_sym, number)
  end

  def self.clear()
    @@create_cache = {}
    @@create_list_cache = {}
    @@build_cache = {}
    @@build_list_cache = {}
    @@build_stubbed_cache = {}
  end
  
end
