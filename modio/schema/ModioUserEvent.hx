package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioUserEvent = {
	/**
	 * Unique id of the event object.
	 */
	var id:Int;
	
	/**
	 * Unique id of the parent game.
	 */
	var game_id:Int;
	
	/**
	 * Unique id of the parent mod.
	 */
	var mod_id:Int;
	
	/**
	 * Unique id of the user who performed the action.
	 */
	var user_id:Int;
	
	/**
	 * Unix timestamp of date the event occurred.
	 */
	var date_added:Int;
	
	/**
	 * Type of event that was triggered. List of possible events:
	 * 
	 * - USER_TEAM_JOIN
	 * - USER_TEAM_LEAVE
	 * - USER_SUBSCRIBE
	 * - USER_UNSUBSCRIBE
	 */
	var event_type:String;
}
