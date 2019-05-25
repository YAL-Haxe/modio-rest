package modio.schema;

/**
 * @see https://docs.mod.io/#team-member-object
 */
typedef ModioTeamMember = {
	/**
	 * Unique team member id.
	 */
	var id:Int;
	
	/**
	 * Contains user data.
	 */
	var user:ModioUser;
	
	/**
	 * Level of permission the user has:
	 * 
	 * 1 = Moderator (can moderate comments and content attached)
	 * 4 = Manager (moderator access, including uploading builds and editing settings except supply and team members)
	 * 8 = Administrator (full access, including editing the supply and team)
	 */
	var level:Int;
	
	/**
	 * Unix timestamp of the date the user was added to the team.
	 */
	var date_added:Int;
	
	/**
	 * Custom title given to the user in this team.
	 */
	var position:String;
}
