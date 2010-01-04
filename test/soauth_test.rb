$LOAD_PATH << File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'soauth'

require 'rubygems'
require 'test/unit'
require 'mocha'

class SOAuthTest < Test::Unit::TestCase
  
  # Required OAuth parameters with dummy values -- these
  # keys are the minimum number of keys required to generate
  # an {OAuth "Authorization" HTTP header}[http://oauth.net/core/1.0/#auth_header]
  OAUTH_REQ_PARAMS = {
    :consumer_key => "consumer_key",
    :consumer_secret => "consumer_secret",
    :access_key => "access_key",
    :access_secret => "access_secret"
  }
  
  # Make sure the custom nonce is used
  def test_custom_nonce
    nonce = Base64.encode64(OpenSSL::Random.random_bytes(32)).gsub(/\W/, '')
    
    oauth_params = OAUTH_REQ_PARAMS.merge(:nonce => nonce)
    assert_equal %{oauth_nonce="#{nonce}"}, %{oauth_nonce="#{SOAuth.header('http://lonelyvegan.com/', oauth_params).match(nonce)[0]}"}
  end
  
  # Make sure the custom timestamp is used
  def test_custom_nonce
    now = Time.now.to_i
    
    oauth_params = OAUTH_REQ_PARAMS.merge(:timestamp => now)
    assert_equal %{oauth_timestamp="#{now}"}, %{oauth_timestamp="#{SOAuth.header('http://lonelyvegan.com/', oauth_params).match(now.to_s)[0]}"}
  end
  
  # Generate a header without an explicit OAuth version (assumes {version 1.0}[http://oauth.net/core/1.0/])
  def test_no_version_specified
    # No OAuth version specified
    oauth_params = OAUTH_REQ_PARAMS
    assert SOAuth.header('http://lonelyvegan.com/', OAUTH_REQ_PARAMS)
  end
  
  # Generate a header without a {signature method}[http://oauth.net/core/1.0/#signing_process] (assumes "HMAC-SHA1")
  def test_no_signature_method_specified
    # No signature method specified
    oauth_params = OAUTH_REQ_PARAMS
    assert SOAuth.header('http://lonelyvegan.com/', OAUTH_REQ_PARAMS)
  end
  
  # Only certain {signature methods}[http://oauth.net/core/1.0/#signing_process] are supported
  def test_unsupported_signature_method
    oauth_params = OAUTH_REQ_PARAMS.merge(:signature_method => "MD5")
    assert_raises(SOAuth::UnsupportedSignatureMethod) { SOAuth.header('http://lonelyvegan.com/', oauth_params) }
  end
  
end