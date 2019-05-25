package modio.schema;

/**
 * @see https://docs.mod.io/#schemamod_media_object
 */
typedef ModioModMedia = {
	/**
	 * ModioArray of YouTube links.
	 */
	var youtube:ModioArray<String>;
	
	/**
	 * ModioArray of SketchFab links.
	 */
	var sketchfab:ModioArray<String>;
	
	/**
	 * ModioArray of image objects (a gallery).
	 */
	var images:ModioArray<ModioImage>;
}
