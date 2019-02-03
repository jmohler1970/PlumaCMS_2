component extends="taffy.core.api"  {

this.name = "PlumaCMS";
this.applicationTimeout 		= createTimeSpan(0, 4, 0, 0);
this.applicationManagement 	= true;

this.ormenabled = true;
this.ormsettings.eventhandling = true;
this.datasource = "PlumaCMS";

variables.framework.docs.APIName = "PlumaCMS REST";
variables.framework.docs.APIVersion = "2.0.0";

this.mappings['/resources'] 	= expandPath('./resources');
this.mappings['/taffy'] 		= expandPath('./taffy');

function onApplicationStart() output="false"	{

	final application.Config = DeserializeJSON(FileRead(expandPath("./config.json"))); // If config.json is invalid, you are in big trouble

	application.i18n = new i18n.i18n();
	application.i18n.setupRequest(); // Can't remember why I called it that.

	return super.onApplicationStart();
	}


function onTaffyRequest(verb, cfc, requestArguments, mimeExt, headers, methodMetaData, matchedURI)	{

	if(!arguments.headers.keyExists("apiKey")){
		return rep({
			'message' : { 'type' 	: 'error', 'content' : '<b>Error:</b> Missing header apiKey.' },
			'time' 	: GetHttpTimeString(now())
			}).withStatus(401);
	}

	if (arguments.headers.apiKey != application.Config.apiKey) {
		return rep({
			'message' : {'type' 	: 'error', 'content' :  '<b>Error:</b> apiKey is invalid.'},
			'time' 	: GetHttpTimeString(now())
			}).withStatus(401);
	}

	// I need a login token and I don't have it.
	if (!application.config.Token.NotRequired.findNoCase(arguments.matchedURI) && !arguments.headers.keyExists("authorization"))	{
		return rep({
			'message' : {'type' 	: 'error', 'content' : '<b>Error:</b> You must provide an authorization header to perform this operation.' },
			'time' 	: GetHttpTimeString(now())
			}).withStatus(403);
	}

	

	// I need a login token and the current one is expired.
	if (!application.config.token.NotRequired.findNoCase(arguments.matchedURI))	{

		// I need a login token and I don't have it.
		if (arguments.headers.authorization == "" || listfirst(arguments.headers.authorization, " ") != "bearer")	{
		return rep({
			'message' : {'type' 	: 'error', 'content' : '<b>Error:</b> You must provide a authorization header that is not blank and starts with Bearer.' },
			'time' 	: GetHttpTimeString(now())
			}).withStatus(403);
		}

		var Login = EntityLoad("Users", { loginToken : listrest(arguments.headers.authorization, " ") }, true);

		if (isNull(Login))	{
			return rep({
				'message' : {'type' 	: 'error', 'content' : '<b>Error:</b> You must provide a authorization that is valid.' },
				'time' 	: GetHttpTimeString(now())
				}).withStatus(401);
		}

		// comparing my minutes
		if (Login.getTokenCreateDate().add("n", application.config.Token.Expiration).compare(now(), "n") < 0 )	{
			return rep({
				'message' : {'type' 	: 'error', 'content' : '<b>Error:</b> Your token has expired. Login again.'},
				'time' 	: GetHttpTimeString(now())
				}).withStatus(403);
		}
	}

	// We only track traffic on valid requests

	if (!application.config.Traffic.NotRequired.findNoCase(arguments.matchedURI)) {
		invoke("services.traffic", "add", {endpoint : arguments.matchedURI, verb : arguments.verb});
	}

	return true;
}
} // end component
