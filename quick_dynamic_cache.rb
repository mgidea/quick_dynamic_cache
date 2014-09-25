# module QuickDynamicCache
require 'pry'
class Object
  def stringy?
    is_a?(String) || is_a?(Symbol)
  end

  def dynamic_instant_cache(name, value = nil)
    if name.stringy?
      set_dynamic_instant_cache(name, value)
    else
      raise "instance name value must be a string or symbol"
    end
  end


  def set_dynamic_instant_cache(name, value = nil)
    instance_name = "@#{name.to_s}"
    unless instance_variable_get(instance_name)
      instance_variable_set(instance_name, value)
    end
    instance_variable_get(instance_name)
  end

  def hashed_cache(name, key_name = nil, *values)
    if key_name
      values.each{|value| cached_hash(name)[key_name] ||= value} if (!values.empty? || !values.nil?)
      cached_hash(name)[key_name]
    else
      cached_hash(name)
    end
  end

  def cached_hash(name)
    dynamic_instant_cache(name, {})
    dynamic_instant_cache(name)
  end

  def clear_hashed_cache(name, key_name = nil, remove_key = true)
    if key_name
     remove_key ? cached_hash(name).delete(key_name) : cached_hash(name)[key_name] = nil
    else
      clear_cached_hash(name)
    end
    hashed_cache(name)
  end

  def clear_cached_hash(name, value = {})
    clear_dynamic_instant_cache(name, value)
  end

  def clear_dynamic_instant_cache(name, value = nil)
    instance_variable_set("@#{name.to_s}", value)
  end
end

months = %w{ jan feb mar apr may jun jul aug sep oct nov dec}
months.each_with_index do |month, index|
  hashed_cache("months", month, index + 1)
end
