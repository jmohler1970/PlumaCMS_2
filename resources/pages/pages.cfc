component extends="taffy.core.resource" taffy_uri="/pages" {

/**
* @hint Return completes set of pages ordered by slug
*/
function get(){

	return rep({
		'data' : queryToArray(EntityToQuery(EntityLoad("Pages", {}, "Slug")))
		});
	}

/**
* @hint Creates new pages, fails if slug already exists
*/
function post(required string slug, required string title, required string content, 
	required string menu, required string menuOrder, required string menuStatus){

	var Page = EntityLoadByPK("Pages", arguments.slug);

	if(!isNull(Page))	{
		return rep({
			"message" : { 'type' : 'error', 'content' : '<b>Error:</b> Page already exists' },
			'data' : ""
			});
	}

	Page = EntityNew("Pages", {
			slug : arguments.slug, 
			title : arguments.title, 
			content : arguments.content,

			menu : arguments.menu,
			menuOrder : arguments.menuOrder,
			menuStatus : arguments.menuStatus,

			author : request.User.getFirstName() & " " & request.User.getLastName(),
			pubdate : now()
			});

	EntitySave(Page);
	ORMFlush();

	return rep({
		'message' : {'type' : 'success', 'content' : '<b>Success:</b> Page has been created.'}
		});
}


} // end component

