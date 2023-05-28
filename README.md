# twitter_tweet_bot
Tweet Bot with Twitter's V2 API.<br/>
（by OAuth 2.0 with PCKE）

## Getting Started

```rb
# Gemfile
gem 'twitter_tweet_bot'
```

Then run `bundle install`.

## Usage

```rb
require 'twitter_tweet_bot'

TwitterTweetBot.post_tweet(<ACEESS_TOKEN>, 'Yeah!')
```

1. Configuration
2. Issue Authorization URL
3. Go to Authorization URL
4. Fetch Access Token
5. Post Tweet

<details>

<summary>Details</summary>

#### Step1. Configuration

```rb
require 'twitter_tweet_bot'

TwitterTweetBot.configure do |config|
  # Twitter's Bot Name (any)
  config.name = 'iambot'
  # Twitter's Client ID
  config.client_id = '*****'
  # Twitter's Client Secret
  config.client_secret = '*****'
  # Redirect URL After Authorization
  config.redirect_uri = 'https://example.com/twitter/callback'
  # Twitter's App Scopes with OAuth 2.0
  config.scopes = ['tweet.read', 'tweet.write', 'users.read', 'offline.access']
end
```

#### Step2. Issue an authorization url

```rb
authorization = TwitterTweetBot.authorize
# =>
#  #<TwitterTweetBot::Entity::Authorization
#   @code_verifier="*****",
#   @state="***",
#   @url="https://twitter.com/i/oauth2/authorize?response_type=code&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&scope=<SCOPES>&code_challenge=*****&code_challenge_method=S256&state=***">
```

#### Step3. Redirect (or Go) to `authorization.url`

And smash `"Authorize app"`.

If authorized, redirected to your `config.redirect_uri`.<br/>
Check **CODE** in Twitter's response.

```
e.g. https://example.com/twitter/callback?state=***&code=*****
```

#### Step4. Fetch an access token

```rb
token = TwitterTweetBot.fetch_token('<CODE>', authorization.code_verifier)
# =>
#  #<TwitterTweetBot::Entity::Token
#   @access_token="<YOUR_ACCESS_TOKEN>",
#   @expires_in=7200,
#   @refresh_token="<YOUR_REFRESH_TOKEN>",
#   @scope="tweet.write users.read tweet.read offline.access",
#   @token_type="bearer">
```

#### Step5. Post a tweet

```rb
TwitterTweetBot.post_tweet(token.access_token, 'Yeah!')
# =>
#  #<TwitterTweetBot::Entity::Tweet
#   @edit_history_tweet_ids=["0123456789"],
#   @id="0123456789",
#   @text="Yeah!">
```

#### Ex. Refresh an access token (required `'offline.access'` in scopes)

```rb
TwitterTweetBot.refresh_token(token.refresh_token)
```
</details>

### Caching

`TwitterTweetBot` can cache follow variables automatically in any store (like `Rails.cache`).

- `code_verifier`
- `state`
- `access_token`
- `refresh_token`

If needed, require `'twitter_tweet_bot/cache'`.

```rb
require 'twitter_tweet_bot/cache'

TwitterTweetBot.post_tweet('Yeah!')
```

<details>

<summary>Details</summary>

#### Step1. Configuration

```rb
require 'twitter_tweet_bot/cache'

TwitterTweetBot.configure do |config|
  # ...

  # Any Cache Store (required `#write(key, value)` and `#read(key)` implementation).
  config.cache_provider = ActiveSupport::Cache.lookup_store(:file_store, '../tmp/cache')
end
```

#### Step2. Issue an authorization url

```rb
# `code_verifier` and `state` will be cached.
TwitterTweetBot.authorize
```

#### Step3. Fetch an access token


```rb
# `access_token` and `refresh_token` will be cached.
TwitterTweetBot.fetch_token('<CODE>')
```

Don't need to pass `code_verifier`.<br/>
(resolved from cache)

#### Step4. Post a tweet

```rb
TwitterTweetBot.post_tweet('Yeah!')
```

Don't need to pass `access_token`.<br/>
(resolved from cache)

#### Ex. Check a cache

```rb
TwitterTweetBot.client.cache.read
# =>
#  { :code_verifier=>"*****", :state=>"***", :access_token=>"*****", :refresh_token=>"*****" }
```
</details>
