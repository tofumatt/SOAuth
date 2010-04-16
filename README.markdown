# SOAuth #
## The "S" is for "Signs" ##

*SOAuth* is a Ruby library that **creates HTTP headers for OAuth Authorization** using previously-obtained OAuth keys/secrets. Useful if you want to make your own HTTP request objects instead of using the ones created for you using the [commonly-used OAuth gem](http://github.com/mojodna/oauth).

It should be noted that this was developed without edge cases in mind -- it was pretty much abstracted from my "by-hand" signing of OAuth requests in [Prey Fetcher](http://preyfetcher.com), so don't consider it production-quality code (though it [is running in production](http://preyfetcher.com)).

Please fork away and send me a pull request if you think you can make it better or handle more use cases.

## Installation ##

Install like any other Ruby gem:

	gem install soauth

## Usage ##

Create an OAuth header by specifying the URI of the resource you're requesting, your consumer key/secret + access key/secret in a hash, and -- optionally -- any GET params in another hash. Check it out:

	uri = 'https://twitter.com/direct_messages.json'
	oauth = {
		:consumer_key => "consumer_key",
		:consumer_secret => "consumer_secret",
		:token => "access_key",
		:token_secret => "access_secret"
	}
	params = {
		'count' => "11",
		'since_id' => "5000"
	}
	oauth_header = SOAuth.header(uri, oauth, params)

Pretty straightforward. You can use whatever HTTP library you like, just use `oauth_header` as the "Authorization" HTTP header to your request (making sure the request info is the same info you passed to SOAuth). Say you were using **NET::HTTP**:

	http_uri = URI.parse(uri)
	request = Net::HTTP.new(http_uri.host, http_uri.port)
	request.get(uri.request_uri, {'Authorization', oauth_header})

## Why Would I Want This? ##

There's already a pretty nice [OAuth library for Ruby out there](http://github.com/mojodna/oauth). But I didn't want to have to use the OAuth library just to make my Authorization headers, and I wanted to be able to plug those headers into whatever HTTP library I wanted (in my case, [Typhoeus](http://github.com/pauldix/typhoeus)). I found using the [OAuth gem](http://github.com/mojodna/oauth) incredibly clunky/overkill for signing requests by hand, so I made SOAuth.

## License ##

This program is free software; it is distributed under an [MIT-style License](http://fosspass.org/license/mit?author=Matthew+Riley+MacPherson&year=2010).

---

Copyright (c) 2010 [Matthew Riley MacPherson](http://lonelyvegan.com).