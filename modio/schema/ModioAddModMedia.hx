package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioAddModMedia = {
	/**
	 * Image file which will represent your mods logo. Must be gif, jpg or png format and cannot exceed 8MB in filesize. Dimensions must be at least 512x288 and we recommended you supply a high resolution image with a 16 / 9 ratio. mod.io will use this logo to create three thumbnails with the dimensions of 320x180, 640x360 and 1280x720.
	 */
	@:optional var logo:ModioFile;
	
	/**
	 * Zip archive of images to upload. Only valid gif, jpg and png images in the zip file will be processed. The filename must be images.zip all other zips will be ignored. Alternatively you can POST one or more images to this endpoint and they will be detected and added to the mods gallery.
	 */
	@:optional var images:ModioFile;
	
	/**
	 * Full Youtube link(s) you want to add - example 'https://www.youtube.com/watch?v=IGVZOLV9SPo'
	 */
	@:optional var youtube:ModioArray<String>;
	
	/**
	 * Full Sketchfab link(s) you want to add - example 'https://sketchfab.com/models/71f04e390ff54e5f8d9a51b4e1caab7e'
	 */
	@:optional var sketchfab:ModioArray<String>;
}
