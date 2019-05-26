package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioDeleteModMedia = {
	/**
	 * Filename's of the image(s) you want to delete - example 'gameplay2.jpg'.
	 */
	@:optional var images:ModioArray<String>;
	
	/**
	 * Full Youtube link(s) you want to delete - example 'https://www.youtube.com/watch?v=IGVZOLV9SPo'.
	 */
	@:optional var youtube:ModioArray<String>;
	
	/**
	 * Full Sketchfab link(s) you want to delete - example 'https://sketchfab.com/models/71f04e390ff54e5f8d9a51b4e1caab7e'.
	 */
	@:optional var sketchfab:ModioArray<String>;
}
