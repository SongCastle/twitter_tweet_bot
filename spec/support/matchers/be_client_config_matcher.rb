RSpec::Matchers.define :be_client_config do |expected|
  match do
    target_keys.all? do |key|
      actual.public_send(key) == expected[key]
    end
  end

  description do
    "be #{diff_expected}"
  end

  failure_message do
    "expected #{diff_actual} to #{description}"
  end

  define_method :diff_actual do
    compose_diff { |key| actual.public_send(key) }
  end
  private :diff_actual

  define_method :diff_expected do
    compose_diff { |key| expected[key] }
  end
  private :diff_expected

  define_method :compose_diff do |&block|
    target_keys.each_with_object({}) do |key, hash|
      hash[key] = block.call(key) if actual.public_send(key) != expected[key]
    end
  end
  private :compose_diff

  define_method :target_keys do
    %i[name client_id client_secret redirect_uri scopes]
  end
  private :target_keys
end
