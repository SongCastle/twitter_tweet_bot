require 'webmock/rspec'

module RequestHelpers
  def a_get(uri)
    a_request(:get, uri)
  end

  def a_post(uri)
    a_request(:post, uri)
  end

  def stub_get(uri)
    stub_request(:get, uri)
  end

  def stub_post(uri)
    stub_request(:post, uri)
  end
end
