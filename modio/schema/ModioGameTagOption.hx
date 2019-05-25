package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioGameTagOption = {
	/**
	 * Name of the tag group.
	 */
	var name:String;
	
	/**
	 * Can multiple tags be selected via 'checkboxes' or should only a single tag be selected via a 'dropdown'.
	 */
	var type:String;
	
	/**
	 * Groups of tags flagged as 'admin only' should only be used for filtering, and should not be displayed to users.
	 */
	var hidden:Bool;
	
	/**
	 * Array of tags in this group.
	 */
	var tags:ModioArray<String>;
}
