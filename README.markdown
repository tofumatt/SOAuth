# SOAuth #
## The "S" is for "Signs" ##

*SOAuth* is a Ruby library that **creates HTTP headers for OAuth Authorization** using previously-obtained OAuth keys/secrets. Useful if you want to make your own HTTP request objects instead of using the ones created for you using the [commonly-used OAuth gem](http://github.com/mojodna/oauth).

## Installation ##

Assuming you have [Gemcutter](http://gemcutter.org/) setup as a gem source, install like any other Ruby gem:

	gem install soauth

If you don't already have [Gemcutter](http://gemcutter.org/) setup as one of your gem sources, install SOAuth with the following command:

	gem install soauth --source http://gemcutter.org/

## Usage ##

Create an OAuth header by specifying the URI of the resource you're requesting, your consumer key/secret and access key/secret in a hash and (optionally) any GET params in another hash. Check it out:

	uri = 'https://twitter.com/direct_messages.json'
	oauth = {
		:consumer_key => "consumer_key",
		:consumer_secret => "consumer_secret",
		:access_key => "access_key",
		:access_secret => "access_secret"
	}
	params = {
		'count' => "11",
		'since_id' => "5000"
	}
	oauth_header = SOAuth.header(uri, oauth, params)

Pretty straightforward.

## Why Would I Want This? ##

There's already a pretty nice [OAuth library for Ruby out there](http://github.com/mojodna/oauth). But I didn't want to have to use the OAuth library just to make my Authorization headers, and I wanted to be able to plug those headers into whatever HTTP library I wanted (in my case, [Typhoeus](http://github.com/pauldix/typhoeus)*).

*As of writing, I know that Typhoeus support is totally getting added into the OAuth gem -- I found it clunky and preferred this solution. In the future, if something even better than Typhoeus comes around, you can switch the library you use for making your authorized requests easily and with haste.

## License ##

This program is free software; it is distributed under an [MIT-style License](http://fosspass.org/license/mit?author=Matthew+Riley+MacPherson&year=2010).

---

Copyright (c) 2010 [Matthew Riley MacPherson](http://lonelyvegan.com).