require 'base64'
require 'openssl'
require 'uri'

class SOAuth
  
  # Exception raised if signature signing method isn't supported
  # by SOAuth
  class UnsupportedSignatureMethod < Exception; end
  # Exception raised when attempting to create a signature without
  # required OAuth params
  class MissingOAuthParams < Exception; end
  
  # Digest key for HMAC-SHA1 signing
  DIGEST = OpenSSL::Digest::Digest.new('sha1')
  # Supported {signature methods}[http://oauth.net/core/1.0/#signing_process];
  # currently, only HMAC-SHA1 is supported
  SUPPORTED_SIGNATURE_METHODS = ["HMAC-SHA1"]
  
  # Return an {OAuth "Authorization" HTTP header}[http://oauth.net/core/1.0/#auth_header] from request data
  def header(uri, oauth, params = {}, http_method = :get)
    # Raise an exception if we're missing required OAuth params
    raise MissingOAuthParams if !oauth.is_a?(Hash) || !oauth.has_key?(:consumer_key) || !oauth.has_key?(:consumer_secret) || !oauth.has_key?(:token) || !oauth.has_key?(:token_secret)
    # Make sure we support the signature signing method specified
    raise UnsupportedSignatureMethod unless !oauth[:signature_method] || SUPPORTED_SIGNATURE_METHODS.include?(oauth[:signature_method].to_s)
    
    oauth[:signature_method] ||= "HMAC-SHA1" # HMAC-SHA1 seems popular, so it's the default
    oauth[:version] ||= "1.0" # Assumed version, according to the spec
    oauth[:nonce] ||= Base64.encode64(OpenSSL::Random.random_bytes(32)).gsub(/\W/, '')
    oauth[:timestamp] ||= Time.now.to_i
    
    # Make a copy of the params hash so we don't add in OAuth stuff
    sig_params = params.dup
    
    oauth.each { |k, v|
      # Only use certain OAuth values for the base string
      if [:consumer_key, :token, :signature_method, :version, :nonce, :timestamp].include?(k)
        sig_params['oauth_' + k.to_s] = v
      end
    }
    
    secret = "#{escape(oauth[:consumer_secret])}&#{escape(oauth[:token_secret])}"
    sig_base = (http_method||'get').to_s.upcase + '&' + escape(uri) + '&' + normalize(sig_params)
    oauth_signature = Base64.encode64(OpenSSL::HMAC.digest(DIGEST, secret, sig_base)).chomp.gsub(/\n/,'')
    
    oauth.merge!(:signature => oauth_signature)
    
    %{OAuth } + (oauth.map { |k, v| %{oauth_#{k}="#{escape(v)}", } unless [:consumer_secret, :token_secret].include?(k) }).to_s.chomp(", ")
  end
  
  # Utility class used to sign a request and return an
  # {OAuth "Authorization" HTTP header}[http://oauth.net/core/1.0/#auth_header]
  def self.header(uri, oauth, params = {}, http_method = :get)
    new.header(uri, oauth, params, http_method)
  end
  
  protected
  
  # Escape characters in a string according to the {OAuth spec}[http://oauth.net/core/1.0/]
  def escape(value)
    URI::escape(value.to_s, /[^a-zA-Z0-9\-\.\_\~]/) # Unreserved characters -- must not be encoded
  end
  
  # Normalize a string of parameters based on the {OAuth spec}[http://oauth.net/core/1.0/#rfc.section.9.1.1]
  def normalize(params)
    params.sort.map do |k, values|
      
      if values.is_a?(Array)
        # Multiple values were provided for a single key
        # in a hash
        values.sort.collect do |v|
          [escape(k), escape(v)] * "%3D"
        end
      else
        [escape(k), escape(values)] * "%3D"
      end
    end * "%26"
  end
  
end