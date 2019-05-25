package modio.schema;

/**
 * @see https://docs.mod.io/#schemastats_object
 */
typedef ModioStats = {
	/**
	 * Unique mod id.
	 */
	var mod_id:Int;
	
	/**
	 * Current rank of the mod.
	 */
	var popularity_rank_position:Int;
	
	/**
	 * Number of ranking spots the current rank is measured against.
	 */
	var popularity_rank_total_mods:Int;
	
	/**
	 * Number of total mod downloads.
	 */
	var downloads_total:Int;
	
	/**
	 * Number of total users who have subscribed to the mod.
	 */
	var subscribers_total:Int;
	
	/**
	 * Number of times this item has been rated.
	 */
	var ratings_total:Int;
	
	/**
	 * Number of positive ratings.
	 */
	var ratings_positive:Int;
	
	/**
	 * Number of negative ratings.
	 */
	var ratings_negative:Int;
	
	/**
	 * Number of positive ratings, divided by the total ratings to determine it’s percentage score.
	 */
	var ratings_percentage_positive:Int;
	
	/**
	 * Overall rating of this item calculated using the Wilson score confidence interval. This column is good to sort on, as it will order items based on number of ratings and will place items with many positive ratings above those with a higher score but fewer ratings.
	 * @see https://www.evanmiller.org/how-not-to-sort-by-average-rating.html
	 */
	var ratings_weighted_aggregate:Float;
	
	/**
	 * Textual representation of the rating in format:
	 * 
	 * - Overwhelmingly Positive
	 * - Very Positive
	 * - Positive
	 * - Mostly Positive
	 * - Mixed
	 * - Negative
	 * - Mostly Negative
	 * - Very Negative
	 * - Overwhelmingly Negative
	 * - Unrated
	 */
	var ratings_display_text:String;
	
	/**
	 * Unix timestamp until this mods's statistics are considered stale.
	 */
	var date_expires:Int;
}
