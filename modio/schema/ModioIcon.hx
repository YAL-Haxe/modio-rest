package modio.schema;

/**
 * @see https://docs.mod.io/#schemaicon_object
 * @author YellowAfterlife
 */
typedef ModioIcon = {
	/**
	 * Icon filename including extension.
	 */
	var filename:String;
	
	/**
	 * URL to the full-sized icon.
	 */
	var original:String;
	
	/**
	 * URL to the small icon thumbnail.
	 */
	var thumb_64x64:String;
	
	/**
	 * URL to the medium icon thumbnail.
	 */
	var thumb_128x128:String;
	
	/**
	 * URL to the large icon thumbnail.
	 */
	var thumb_256x256:String;
}
