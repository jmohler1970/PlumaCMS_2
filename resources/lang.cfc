component extends="taffy.core.resource" taffy_uri="/lang" {


function get() {

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