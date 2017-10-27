# Defines shared configuration between all rest client modules.

settings = {
	
	 # The username to use when  authenticating with the server
	'username' 			: 'Administrator',

	 # The password to use when authentication with the server
	'password' 			: 'Administrator',

	 # The base address for all service endpoints
	'base_address' 		: 'http://vpcs-ewb19:6060/ewb/services/1.0/',

	 # Default headers to add to each request
	'default_headers'	: {
		'Accept' : 'application/json;charset=utf-8',
		'Content-Type' : 'application/json;charset=utf-8'
	},
	
	 # XML headers to add to each request	
	'xml_headers'		: {
		'Accept' : 'application/json;charset=utf-8',
		'Content-Type' : 'application/xml;charset=utf-8'
	}
				
}
