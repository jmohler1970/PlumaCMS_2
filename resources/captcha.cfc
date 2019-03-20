component extends="taffy.core.resource" taffy_uri="/login/captcha" {


/**
* @hint Create captcha image
* @complexity This goes into ImapeCreateCaptcha(). This can get strange very fast. 
*/
function get(string complexity = "low")  {

	var CAPTCHAConf = application.Config.CAPTCHA;

	var captcha = "";

	for (var sliceLength in CAPTCHAConf.slices)	{
		captcha	&= CAPTCHAConf.data.mid(randrange(1, len(CAPTCHAConf.data) - sliceLength), sliceLength);
	}


	// This is ColdFusion
	var tempFile = "ram:///#captcha#.txt";

	var myImage = ImageCreateCaptcha(120, 360, captcha, arguments.complexity, "sansserif", 30);

	ImageWriteBase64(myImage, tempFile, "png", true, true);

	var myfile = FileRead(tempFile);
	FileDelete(tempFile);


	return rep({
		'data' : {
			'captcha_hash' : hash(captcha, application.Config.hash_algorithm),
			'captcha_image' : myFile
			}
		});
}


/**
* @hint Verifies results. It is more common to tied this in with contactus or resetpassword
* @captcha This is what the user thinks is the captcha string.
* @captcha_hash This is the known hash of the string. We never push a plain-text version of the captcha because that would defeat the purpose of captcha.
*/
function post(required string captcha, required string captcha_hash) hint="" {

	if (hash(arguments.captcha, application.Config.hash_algorithm) != arguments.captcha_hash)	{
		return rep({
			'message' : { 'type' : 'failure', 'content' : '<b>Failure</b>: CAPTCHA respone does not match' }
		}).withStatus(404);
	}

	return rep({
		message : {'type' : 'success', 'content' : 'CAPTCHA is valid' }
		});
}

} // end component
