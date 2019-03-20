component extends="taffy.core.resource" taffy_uri="/pages/{id}" {


/**
* @hint Return completes single page slug
* @id Slug to get the page
*/
function get(required string id){

	var Page = EntityLoadByPK("Pages", arguments.id);

	if(isNull(Page))	{
		return rep({
			"message" : { 'type' : 'error', 'content' : '<b>Error:</b> Page could not be found' },
			'data' : ""
			});
	}

	return rep({
		'data' : queryToArray(EntityToQuery())
		});

}

/**
* @hint Updates single page based on slug
* @id Slug to get the page
*/
function put(required string slug, required string title, required string content, 
	required string menu, required string menuOrder, required string menuStatus){

	var Page = EntityLoadByPK("Pages", arguments.slug);

	if(isNull(Page))	{
		return rep({
			"message" : { 'type' : 'error', 'content' : '<b>Error:</b> Page could not be found' },
			'data' : ""
			});
	}

	Page.setSlug(arguments.slug)
		.setTitle(arguments.title)
		.setContent(arguments.content)
		.setMenu(arguments.menu)
		.setMenuOrder(arguments.menuOrder)
		.setMenuStatus(arguments.menuStatus);
	
	EntitySave(Page);
	ORMFlush();

	return rep({
		'message' : {'type' : 'success', 'content' : '<b>Success:</b> Page has been updated.'}
		});
}




/**
* @hint Always returns success
* @id Slug to delete the page
*/
function delete(required string id) {

	entityDelete(EntityLoadByPK("Pages", arguments.id));

	return rep({
		'message' : {
			'type' : 'success', 
			'content' : '<b>Success:</b> You have deleted a page.'
			}
		});
}


} // end component

