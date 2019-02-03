component extends="taffy.core.resource" taffy_uri="/lang" {


function get() {

	return rep({
		'message' : {
			'type' : 'success'
			},
		'data' : application.i18n.getLang();
		});

}

} // end component