component extends="taffy.core.resource" taffy_uri="/settings" {


function get() {

	var settings = {};

	for (var setting in EntityLoad("Settings")) {
		settings[setting.key] = setting.value;
	}


	return rep({
		'message' : {
			'type' : 'success'
			},
		'data' : settings
		});

}

// These get pushed all at once
function put(required struct settings) {

	for (var key in arguments.settings)	{
		var setting = EntityLoadByPK("Settings", key);

		if(isNull(setting))	{
			setting = EntityNew("Settings", { key : key});
		}

		setting.setValue(arguments.settings[key]);
		EntitySave(setting);
	}

	return this.get();

}

/**
* @hint Remove setting.  Entire set of settings is returned because we are expecting instant response.
*/
function delete(required string key) {

	EntityDelete(EntityLoadByPK("Settings", arguments.key));

	return this.get();
}

} // end component