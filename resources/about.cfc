component extends="taffy.core.resource" taffy_uri="/about" {


function get() hint="Returns the contents in about.json. Do not include any sensitive information in this file" {


	return rep({
		'message' : {
			'type' : 'success', 
			'content' : '<b>Success:</b> You have logged in.'
			},
		'data' : DeserializeJSON(FileRead(expandPath("./about.json")))
		});

}

} // end component