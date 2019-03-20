
/**
* @hint A fragment is a part of a page. It may be quite long. It can be part of a sidebar or footer
*/
component extends="taffy.core.resource" taffy_uri="/pages/fragments" {

/**
* @hint All fragments are returned. This function is used for both management only Live pages get it via /wiki
*/
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

/**
* @hint Add a new fragment. Entire set of fragments is returned because we are expecting instant response.
*/
function put(required string key, required string value) {


	if(isNull(fragment))	{
		fragment = EntityNew("Fragments", {key : arguments.key, value : arguments.value});
	}
	else	{
		fragment.setValue(arguments.value);
	}
	EntitySave(fragment);

	return this.get();

}

/**
* @hint Remove fragment.  Entire set of fragments is returned because we are expecting instant response.
*/
function delete(required string key) {

	EntityDelete(EntityLoadByPK("Fragments", arguments.key));

	return this.get();
}

} // end component