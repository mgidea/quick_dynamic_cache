# module QuickDynamicCache
class Object
  def stringy?
    is_a?(String) || is_a?(Symbol)
  end

  def dynamic_instant_cache(name, value = nil)
    if name.stringy?
      set_dynamic_instant_cache(name, value)
    else
      raise "instance variable value must be a string or symbol"
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
    hash = cached_hash(name)
    if key_name && (!values.empty? || !values.nil?)
      key_name = *key_name
      values.each{|value| hash_it(hash, value, key_name)}
    else
      hash
    end
  end

  def hash_it(name, value = nil, keys = nil)
    unless name.is_a?(Hash)
      name = cached_hash(name)
    end
    if keys
      key_name = (keys.is_a?(Array) && keys.size == 1) ? keys.first : keys
      if keys.is_a?(Array) && keys.size > 1
        cache_it = name
        keys.each_with_index do |key, index|
          assignment = index == (keys.size - 1) ? value : {}
          cache_it[key] ||= assignment
          cache_it = cache_it[key]
        end
      else
        name[key_name] ||= value
        name[key_name]
      end
    end
  end

  def string_in_hash(object)
    object.is_a?(String) ? "'#{object}'" : "#{object}"
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

  def method_missing(meth, *args, &block)
    if meth.to_s.end_with?("1!")
      if respond_to?(meth.to_s[0...-2])
        item = send(meth.to_s[0...-2])
        (item.respond_to?(:first) && item.first) ? item.first : nil
      end
    else
      super(meth, *args, &block)
    end
  end
end

