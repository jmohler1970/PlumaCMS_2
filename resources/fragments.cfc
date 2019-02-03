component extends="taffy.core.resource" taffy_uri="/pages/fragments" {


function get() {

	var fragments = {};

	for (var fragment in EntityLoad("Fragments")) {
		fragment[setting.key] = fragment.value;
	}


	return rep({
		'message' : {
			'type' : 'success'
			},
		'data' : fragments
		});

}

function put(required string key, required string value) {

	var fragment = EntityLoadByPK("Fragments", arguments.key);

	if(isNull(fragment))	{
		fragment = EntityNew("Fragments", {key : arguments.key, value : arguments.value});
	}
	else	{
		fragment.setValue(arguments.value);
	}
	EntitySave(fragment);


	return rep({
		'message' : {
			'type' : 'success'
			},
		'data' : fragments
		});

}


} // end component