package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioEditGame = {
	/**
	 * Status of a game. We recommend you never change this once you have accepted your game to be available via the API (see status and visibility for details):
	 * 
	 * 0 = Not accepted
	 * 1 = Accepted
	 * @see https://docs.mod.io/#status-amp-visibility
	 */
	@:optional var status:Int;
	
	/**
	 * Name of your game. Cannot exceed 80 characters.
	 */
	@:optional var name:String;
	
	/**
	 * Subdomain for the game on mod.io. Highly recommended to not change this unless absolutely required. Cannot exceed 20 characters.
	 */
	@:optional var name_id:String;
	
	/**
	 * Explain your games mod support in 1 paragraph. Cannot exceed 250 characters.
	 */
	@:optional var summary:String;
	
	/**
	 * Instructions and links creators should follow to upload mods. Keep it short and explain details like are mods submitted in-game or via tools you have created.
	 */
	@:optional var instructions:String;
	
	/**
	 * Link to a mod.io guide, your modding wiki or a page where modders can learn how to make and submit mods to your games profile.
	 */
	@:optional var instructions_url:String;
	
	/**
	 * Word used to describe user-generated content (mods, items, addons etc).
	 */
	@:optional var ugc_name:String;
	
	/**
	 * Choose the presentation style you want on the mod.io website:
	 * 
	 * 0 = Grid View: Displays mods in a grid (visual but less informative, default setting)
	 * 1 = Table View: Displays mods in a table (easier to browse)
	 */
	@:optional var presentation_option:Int;
	
	/**
	 * Choose the submission process you want modders to follow:
	 * 
	 * 0 = Mods must be uploaded using your tools (recommended): You will have to build an upload system either in-game or via a standalone tool, which enables creators to submit mods to the tags you have configured. Because you control the flow you can prevalidate and compile mods, to ensure they will work in your game and attach metadata about what settings the mod can change. In the long run this option will save you time as you can accept more submissions, but it requires more setup to get running and isn't as open as the above option. NOTE: mod profiles can still be created online, but uploads will have to occur via the API using tools you create.
	 * 
	 * 1 = Mods can be uploaded using the website: Allow developers to upload mods via the website and API, and pick the tags their mod is built for. No validation will be done on the files submitted, it will be the responsibility of your game and apps to process the mods installation based on the tags selected and determine if the mod is valid and works. For example a mod might be uploaded with the 'map' tag. When a user subscribes to this mod, your game will need to verify it contains a map file and install it where maps are located. If this fails, your game or the community will have to flag the mod as 'incompatible' to remove it from the listing.
	 * @see https://mod.io/mods/add
	 */
	@:optional var submission_option:Int;
	
	/**
	 * Choose the curation process your team follows to approve mods:
	 * 
	 * 0 = No curation (recommended): Mods are immediately available to play, without any intervention or work from your team.
	 * 
	 * 1 = Paid curation: Screen only mods the creator wants to sell, before they are available to receive donations or be purchased via the API.
	 * 
	 * 2 = Full curation: All mods must be accepted by someone on your team. This option is useful for games that have a small number of mods and want to control the experience, or you need to set the parameters attached to a mod (i.e. a weapon may require the rate of fire, power level, clip size etc). It can also be used for complex mods, which you may need to build into your game or distribute as DLC.
	 */
	@:optional var curation_option:Int;
	
	/**
	 * Choose the community features enabled on the mod.io website:
	 * 
	 * 0 = All of the options below are disabled
	 * 1 = Discussion board enabled
	 * 2 = Guides and news enabled
	 * ? = Add the options you want together, to enable multiple features (see BITWISE fields)
	 * @see https://docs.mod.io/#bitwise-and-bitwise-and
	 */
	@:optional var community_options:Int;
	
	/**
	 * Choose the revenue capabilities mods can enable:
	 * 
	 * 0 = All of the options below are disabled
	 * 1 = Allow mods to be sold
	 * 2 = Allow mods to receive donations
	 * 4 = Allow mods to be traded (not subject to revenue share)
	 * 8 = Allow mods to control supply and scarcity
	 * ? = Add the options you want together, to enable multiple features (see BITWISE fields)
	 * @see https://docs.mod.io/#bitwise-and-bitwise-and
	 */
	@:optional var revenue_options:Int;
	
	/**
	 * Choose the level of API access your game allows:
	 * 
	 * 0 = All of the options below are disabled
	 * 
	 * 1 = Allow 3rd parties to access this games API endpoints. We recommend you enable this feature, an open API will encourage a healthy ecosystem of tools and apps. If you do not enable this feature, your /games/{games-id} endpoints will return 403 Forbidden unless you are a member of the games team or using the games api_key
	 * 
	 * 2 = Allow mods to be downloaded directly (makes implementation easier for you, game servers and services because you can save, share and reuse download URLs). If disabled all download URLs will contain a frequently changing verification hash to stop unauthorized use
	 * 
	 * ? = Add the options you want together, to enable multiple features (see BITWISE fields)
	 * @see https://docs.mod.io/#bitwise-and-bitwise-and
	 */
	@:optional var api_access_options:Int;
	
	/**
	 * Choose if you want to allow developers to select if they can flag their mods as containing mature content:
	 * 
	 * 0 = Don't allow (default)
	 * 1 = Allow
	 */
	@:optional var maturity_options:Int;
}
