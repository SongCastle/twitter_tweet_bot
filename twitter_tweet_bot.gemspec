lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'twitter_tweet_bot/version'

Gem::Specification.new do |s|
  s.name        = 'twitter_tweet_bot'
  s.version     = TwitterTweetBot::Version.current
  s.platform    = Gem::Platform::RUBY
  s.licenses    = 'MIT'
  s.summary     = 'Ruby implementation for Twitter twetting client'
  s.email       = '-'
  s.homepage    = 'https://github.com/SongCastle/twitter_tweet_bot'
  s.description = 'Ruby implementation for Twitter client, using V2 API and OAuth 2.0.'
  s.author      = 'SongCastle'

  s.files                 = Dir['lib/**/*', 'README.md']
  s.require_paths         = ['lib']
  s.required_ruby_version = Gem::Requirement.new('>= 3.0')

  s.add_dependency('activesupport', '>= 6.0.3')
end
