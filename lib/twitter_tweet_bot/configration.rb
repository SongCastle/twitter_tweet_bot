module TwitterTweetBot
  class Configration
    attr_accessor :name,
                  :client_id,
                  :client_secret,
                  :redirect_uri,
                  :scopes

    def initialize(
      name: nil,
      client_id: nil,
      client_secret: nil,
      redirect_uri: nil,
      scopes: []
    )
      @name = name
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
      @scopes = scopes

      yield self if block_given?
    end

    def to_hash
      instance_variables.each_with_object({}) do |key, hash|
        hash[key[1..].to_sym] = instance_variable_get(key)
      end
    end
  end
end
