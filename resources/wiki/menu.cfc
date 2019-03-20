component extends="taffy.core.resource" taffy_uri="/menu" {

/**
* @hint Return complete menu. Note that pages that participate in the menu have to be added first
*/
function get() {

	return rep({
		'data' : queryToArray(EntityToQuery(EntityLoad("Pages", { menuStatus : 1 }, "MenuOrder")))
	});

}



} // end component
