module QuickDynamicCache
  def dynamic_instant_cache(name, value = nil)
    instance_name = "@#{name}"
    unless instance_variable_get(instance_name)
      instance_variable_set(instance_name, value)
    end
    instance_variable_get(instance_name)
  end

  def hashed_cache(name, key_name, value = nil)
    cached_hash(name)[key_name] ||= value
    cached_hash(name)[key_name]
  end

  def cached_hash(name)
    dynamic_instant_cache(name, {})
  end

  def clear_hashed_cache(name, key_name)
    cached_hash(name)[key_name] = nil
  end

  def clear_cached_hash(name)
    clear_dynamic_instant_cache(name)
  end

  def clear_dynamic_instant_cache(name)
    instance_variable_set("@#{name}", nil)
  end
end
