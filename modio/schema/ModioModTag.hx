package modio.schema;

/**
 * @see https://docs.mod.io/#mod-tag-object
 */
typedef ModioModTag = {
	/**
	 * Tag name.
	 */
	var name:String;
	
	/**
	 * Unix timestamp of date tag was applied.
	 */
	var date_added:Int;
}
