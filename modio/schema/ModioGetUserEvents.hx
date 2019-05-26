package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioGetUserEvents = {
	/**
	 * Array containing user event objects.
	 */
	var data:ModioArray<ModioUserEvent>;
	
	/**
	 * Number of results returned in this request.
	 */
	var result_count:Int;
	
	/**
	 * Number of results skipped over. Defaults to 0 unless overridden by _offset filter.
	 */
	var result_offset:Int;
	
	/**
	 * Maximum number of results returned in the request. Defaults to 100 (max) unless overridden by _limit filter.
	 */
	var result_limit:Int;
	
	/**
	 * Total number of results found.
	 */
	var result_total:Int;
}
