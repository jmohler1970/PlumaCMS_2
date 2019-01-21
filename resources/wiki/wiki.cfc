component extends="taffy.core.resource" taffy_uri="/wiki/{id}" {


function get(required string slug) {

	var Page = EntityLoadByPK("Pages", arguments.slug);
	var Menu = EntityLoad("Pages", { MenuStatus : 1 }, "MenuOrder")

	var Result = {"page" : {}, "menu" : {}};

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
