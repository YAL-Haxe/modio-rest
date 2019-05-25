package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioRating = {
	/**
	 * Unique game id.
	 */
	var game_id:Int;
	
	/**
	 * Unique mod id.
	 */
	var mod_id:Int;
	
	/**
	 * Is it a positive or negative rating.
	 */
	var rating:Int;
	
	/**
	 * Unix timestamp of date rating was submitted.
	 */
	var date_added:Int;
}
