package modio.schema;

/**
 * @see https://docs.mod.io/#comment-object
 */
typedef ModioComment = {
	/**
	 * Unique id of the comment.
	 */
	var id:Int;
	
	/**
	 * Unique id of the parent mod.
	 */
	var mod_id:Int;
	
	/**
	 * Contains user data.
	 */
	var user:ModioUser;
	
	/**
	 * Unix timestamp of date the comment was posted.
	 */
	var date_added:Int;
	
	/**
	 * Id of the parent comment this comment is replying to (can be 0 if the comment is not a reply).
	 */
	var reply_id:Int;
	
	/**
	 * Levels of nesting in a comment thread. How it works:
	 * 
	 * - The first comment will have the position '01'.
	 * - The second comment will have the position '02'.
	 * - If someone responds to the second comment the position will be '02.01'.
	 * - A maximum of 3 levels is supported.
	 */
	var thread_position:String;
	
	/**
	 * Karma received for the comment (can be postive or negative).
	 */
	var karma:Int;
	
	/**
	 * Karma received for guest comments (can be postive or negative).
	 */
	var karma_guest:Int;
	
	/**
	 * Contents of the comment.
	 */
	var content:String;
}
