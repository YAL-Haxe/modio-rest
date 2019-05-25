package modio.schema;

/**
 * @see https://docs.mod.io/#schemaimage_object
 */
typedef ModioImage = {
	/**
	 * Image filename including extension.
	 */
	var filename:String;
	
	/**
	 * URL to the full-sized image.
	 */
	var original:String;
	
	/**
	 * URL to the image thumbnail.
	 */
	var thumb_320x180:String;
}
