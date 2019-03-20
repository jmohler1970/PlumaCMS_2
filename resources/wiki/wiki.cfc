component extends="taffy.core.resource" taffy_uri="/wiki/{id}" {

/**
* @hint Return complete wiki page AKA page + settings + fragments + menu
* @id Slug pointing to data
*/
function get(required string id) {

	var Result = {"page" : {}, "menu" : {}};

	var Page = EntityLoadByPK("Pages", arguments.id);
	var Menu = EntityLoad("Pages", { MenuStatus : 1 }, "MenuOrder");

	for (var fragment in EntityLoad("Fragments")) {
		Result.fragments[setting.key] = fragment.value;
	}

	for (var setting in EntityLoad("Settings")) {
		Result.settings[setting.key] = setting.value;
	}

	// expecting 0,1 are valid
	if (!isNull(Page)) {
		Result.page = queryToArray(EntityToQuery(Page));
	}

	// expecting 0,1,infinite are valid
	if (!isNull(Menu)) {
		Result.menu = queryToArray(EntityToQuery(Menu));
	}


	return rep({ data : Result});
}



} // end component
