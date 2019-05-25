package modio.schema;

/**
 * @see https://docs.mod.io/#schemaavatar_object
 * @author YellowAfterlife
 */
typedef ModioAvatar = {
	/**
	 * Avatar filename including extension.
	 */
	var filename:String;
	
	/**
	 * URL to the full-sized avatar.
	 */
	var original:String;
	
	/**
	 * URL to the small avatar thumbnail.
	 */
	var thumb_50x50:String;
	
	/**
	 * URL to the medium avatar thumbnail.
	 */
	var thumb_100x100:String;
}
