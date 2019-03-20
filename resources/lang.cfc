component extends="taffy.core.resource" taffy_uri="/lang" {


function get() hint="All of the languages currently supported by the system" {

	var arLang = application.i18n.getLang();
	arLang.each(
		function(item, index, array) {
			array[index] = item.lang;
		});

	return rep({
		'message' : {
			'type' : 'success'
			},
		'data' : arLang
		});

}

} // end component