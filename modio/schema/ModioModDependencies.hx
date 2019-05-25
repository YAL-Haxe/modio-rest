package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioModDependencies = {
	/**
	 * Unique id of the mod that is the dependency.
	 */
	var mod_id:Int;
	
	/**
	 * Unix timestamp of date the dependency was added.
	 */
	var date_added:Int;
}
