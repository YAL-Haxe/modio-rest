package modio.schema;

/**
 * ...
 * @see https://docs.mod.io/#game-object
 * @author YellowAfterlife
 */
typedef ModioGame = {
	/**
	 * Unique game id.
	 */
	var id:Int;
	
	/**
	 * Status of the game (see status and visibility for details):
	 * 
	 * 0 = Not Accepted
	 * 1 = Accepted
	 * 2 = Archived (potentially out of date or incompatible)
	 * 3 = Deleted
	 * @see https://docs.mod.io/#status-amp-visibility
	 */
	var status:Int;
	
	/**
	 * Contains user data.
	 */
	var submitted_by:ModioUser;
	
	/**
	 * Unix timestamp of date game was registered.
	 */
	var date_added:Int;
	
	/**
	 * Unix timestamp of date game was updated.
	 */
	var date_updated:Int;
	
	/**
	 * Unix timestamp of date game was set live.
	 */
	var date_live:Int;
	
	/**
	 * Presentation style used on the mod.io website:
	 * 
	 * 0 = Grid View: Displays mods in a grid
	 * 1 = Table View: Displays mods in a table
	 */
	var presentation_option:Int;
	
	/**
	 * Submission process modders must follow:
	 * 
	 * 0 = Mod uploads must occur via the API using a tool created by the game developers
	 * 1 = Mod uploads can occur from anywhere, including the website and API
	 */
	var submission_option:Int;
	
	/**
	 * Curation process used to approve mods:
	 * 
	 * 0 = No curation: Mods are immediately available to play
	 * 1 = Paid curation: Mods are immediately available to play unless they choose to receive donations. These mods must be accepted to be listed
	 * 2 = Full curation: All mods must be accepted by someone to be listed
	 */
	var curation_option:Int;
	
	/**
	 * Community features enabled on the mod.io website:
	 * 
	 * 0 = All of the options below are disabled
	 * 1 = Discussion board enabled
	 * 2 = Guides and news enabled
	 * ? = Add the options you want together, to enable multiple features (see BITWISE fields)
	 * @see https://docs.mod.io/#bitwise-and-bitwise-and
	 */
	var community_options:Int;
	
	/**
	 * Revenue capabilities mods can enable:
	 * 
	 * 0 = All of the options below are disabled
	 * 1 = Allow mods to be sold
	 * 2 = Allow mods to receive donations
	 * 4 = Allow mods to be traded
	 * 8 = Allow mods to control supply and scarcity
	 * ? = Add the options you want together, to enable multiple features (see BITWISE fields)
	 * @see https://docs.mod.io/#bitwise-and-bitwise-and
	 */
	var revenue_options:Int;
	
	/**
	 * Level of API access allowed by this game:
	 * 
	 * 0 = All of the options below are disabled
	 * 1 = Allow 3rd parties to access this games API endpoints
	 * 2 = Allow mods to be downloaded directly (if disabled all download URLs will contain a frequently changing verification hash to stop unauthorized use)
	 * ? = Add the options you want together, to enable multiple features (see BITWISE fields)
	 * @see https://docs.mod.io/#bitwise-and-bitwise-and
	 */
	var api_access_options:Int;
	
	/**
	 * Switch to allow developers to select if they flag their mods as containing mature content:
	 * 
	 * 0 = Don't allow (default)
	 * 1 = Allow
	 */
	var maturity_options:Int;
	
	/**
	 * Word used to describe user-generated content (mods, items, addons etc).
	 */
	var ugc_name:String;
	
	/**
	 * Contains icon data.
	 */
	var icon:ModioIcon;
	
	/**
	 * Contains logo data.
	 */
	var logo:ModioLogo;
	
	/**
	 * Contains header data.
	 */
	var header:ModioHeaderImage;
	
	/**
	 * Name of the game.
	 */
	var name:String;
	
	/**
	 * Subdomain for the game on mod.io.
	 */
	var name_id:String;
	
	/**
	 * Summary of the game.
	 */
	var summary:String;
	
	/**
	 * A guide about creating and uploading mods for this game to mod.io (applicable if submission_option = 0).
	 */
	var instructions:String;
	
	/**
	 * Link to a mod.io guide, your modding wiki or a page where modders can learn how to make and submit mods to your games profile.
	 */
	var instructions_url:String;
	
	/**
	 * URL to the game's mod.io page.
	 */
	var profile_url:String;
	
	/**
	 * Groups of tags configured by the game developer, that mods can select.
	 */
	var tag_options:ModioArray<ModioGameTagOption>;
}
