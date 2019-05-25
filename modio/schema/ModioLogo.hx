package modio.schema;

/**
 * @see https://docs.mod.io/#schemalogo_object
 * @author YellowAfterlife
 */
typedef ModioLogo = {
	/**
	 * Logo filename including extension.
	 */
	var filename:String;
	
	/**
	 * URL to the full-sized logo.
	 */
	var original:String;
	
	/**
	 * URL to the small logo thumbnail.
	 */
	var thumb_320x180:String;
	
	/**
	 * URL to the medium logo thumbnail.
	 */
	var thumb_640x360:String;
	
	/**
	 * URL to the large logo thumbnail.
	 */
	var thumb_1280x720:String;
}
