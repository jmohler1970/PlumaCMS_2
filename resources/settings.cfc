component extends="taffy.core.resource" taffy_uri="/settings" {


function get() {

	var settings = {};

	for (var setting in EntityLoad("Settings")) {
		settings[setting.key] = setting.value;
	}


	return rep({
		'message' : {
			'type' : 'success', 
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

	return rep({
		'message' : {
			'type' : 'success', 
			}
	});	

}


} // end component