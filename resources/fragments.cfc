component extends="taffy.core.resource" taffy_uri="/pages/fragments" {


function get() {

	var fragments = {};

	for (var fragment in EntityLoad("Fragments")) {
		fragment[setting.key] = fragment.value;
	}


	return rep({
		'message' : {
			'type' : 'success', 
			},
		'data' : fragments
		});

}

function put() {


}


} // end component