package modio;
import modio.type.*;
import modio.enums.*;
import modio.schema.*;
import modio.ModioCore.*;
import modio.__macro.ModioMacro.*;

/**
 * ...
 * @author YellowAfterlife
 */
#if (js) @:expose("Modio") #end
@:doc @:keep class Modio {
	
	@:doc public static var gameId:Int = -1;
	
	/**
	 * HTTP status code of the latest request
	 */
	@:doc public static var status:Int = 200;
	
	/**
	 * Error text of latest request (null if no errors)
	 */
	@:doc public static var errorText:String = null;
	
	@:access(modio.ModioCore)
	public static function init(_environment:ModioEnvironment, _gameId:Int, _apiKey:String) {
		ModioCore.apiKey = _apiKey;
		ModioCore.environment = _environment;
		ModioCore.reqServer = environment == Test ? "https://api.test.mod.io/v1" : "https://api.mod.io/v1";
		gameId = _gameId;
	}
	
	/** @see https://docs.mod.io/#authentication */
	@:access(modio.ModioCore)
	public static function setUserToken(userAuthToken:String) {
		ModioCore.userToken = userAuthToken;
	}
	
	#if (sys && target.threaded)
	public static function update():Void {
		modio.core.ModioReq.update();
	}
	#end
	
	//{ Helpers
	/** @see https://docs.mod.io/#pagination */
	@:access(modio.ModioCore)
	public static function setPagination(offset:Int, limit:Int):Void {
		ModioCore.reqPagination = true;
		ModioCore.reqPaginationOffset = offset;
		ModioCore.reqPaginationLimit = limit;
	}
	
	/** @see https://docs.mod.io/#filtering */
	@:access(modio.ModioCore)
	public static function addFilters(filters:Array<ModioFilter>):Void {
		ModioCore.reqFilters = ModioCore.reqFilters.concat(filters);
	}
	//}
	
	//{ Auth
	
	/** @see https://docs.mod.io/#step-1-requesting-a-security-code */
	public static function emailRequest<T>(email:String, fn:ModioFunc<ModioMessage, T>, ?custom:T):Void {
		reqStart("POST", "/oauth/emailrequest");
		reqAdd("email", email);
		reqAddAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#step-2-exchanging-security-code-for-access-token */
	public static function emailExchange<T>(securityCode:String, fn:ModioFunc<ModioAccessToken, T>, ?custom:T):Void {
		reqStart("POST", "/oauth/emailexchange");
		reqAdd("security_code", securityCode);
		reqAddAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#authenticate-via-steam */
	public static function steamAuth<T>(appdata_b64:String, fn:ModioFunc<ModioAccessToken, T>, ?custom:T):Void {
		reqStart("POST", "/external/steamauth");
		reqAddAppKeyToURL();
		reqAdd("appdata", appdata_b64);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#authenticate-via-gog-galaxy */
	public static function galaxyAuth<T>(appdata_b64:String, fn:ModioFunc<ModioAccessToken, T>, ?custom:T):Void {
		reqStart("POST", "/external/galaxyauth");
		reqAddAppKeyToURL();
		reqAdd("appdata", appdata_b64);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#link-external-account */
	public static function externalLink<T>(service:String, service_id:String, email:String, fn:ModioFunc<ModioMessage, T>, ?custom:T):Void {
		reqStart("POST", "/external/galaxyauth");
		reqAddUserToken();
		reqAdd("service", service);
		reqAdd("service_id", service_id);
		reqAdd("email", email);
		reqSend(fn, custom);
	}
	
	//}
	
	//{ Games
	/** @see https://docs.mod.io/#get-all-games */
	public static function getAllGames<T>(filters:Array<ModioFilter>, fn:ModioFunc<ModioGetAllGames, T>, ?custom:T, ?sort:String):Void {
		reqStart("GET", "/games");
		reqAddUserTokenOrAppKey();
		reqAddFilters(filters);
		if (sort != null) reqAdd("_sort", sort);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-game */
	public static function getGame<T>(game_id:Int, fn:ModioFunc<ModioGame, T>, ?custom:T):Void {
		reqStart("GET", "/games/" + game_id);
		reqAddUserTokenOrAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#edit-game */
	public static function editGame<T>(game_id:Int, fields:ModioEditGame, fn:ModioFunc<ModioGame, T>, ?custom:T):Void {
		reqStart("PUT", "/games/" + game_id);
		reqAddUserToken();
		reqAddTypedef(fields);
		reqSend(fn, custom);
	}
	//}
	
	//{ Mods
	/** @see https://docs.mod.io/#get-all-mods */
	public static function getAllMods<T>(filters:Array<ModioFilter>, fn:ModioFunc<ModioGetAllMods, T>, ?custom:T, ?sort:String):Void {
		reqStart("GET", '/games/$gameId/mods');
		reqAddUserTokenOrAppKey();
		reqAddFilters(filters);
		if (sort != null) reqAdd("_sort", sort);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-mod */
	public static function getMod<T>(mod_id:Int, fn:ModioFunc<ModioMod, T>, ?custom:T):Void {
		reqStart("GET", '/games/$gameId/mods/' + mod_id);
		reqAddUserTokenOrAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#add-mod */
	public static function addMod<T>(data:ModioAddMod, fn:ModioFunc<ModioMod, T>, ?custom:T):Void {
		reqStart("POST", '/games/$gameId/mods');
		reqAddUserToken();
		reqAddTypedef(data);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#edit-mod */
	public static function editMod<T>(mod_id:Int, fields:ModioEditMod, fn:ModioFunc<ModioMod, T>, ?custom:T):Void {
		reqStart("PUT", '/games/$gameId/mods/' + mod_id);
		reqAddUserToken();
		reqAddTypedef(fields);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#delete-mod */
	public static function deleteMod<T>(mod_id:Int, fn:ModioFunc<ModioBlank, T>, ?custom:T):Void {
		reqStart("DELETE", '/games/$gameId/mods/' + mod_id);
		reqAddUserToken();
		reqSend(fn, custom);
	}
	//}
	
	//{ Files
	/** @see https://docs.mod.io/#get-all-modfiles */
	public static function getAllModfiles<T>(mod_id:Int, filters:Array<ModioFilter>, fn:ModioFunc<ModioGetAllModfiles, T>, ?custom:T):Void {
		reqStart("GET", '/games/$gameId/mods/$mod_id/files');
		reqAddUserTokenOrAppKey();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-modfile */
	public static function getModfile<T>(mod_id:Int, file_id:Int, fn:ModioFunc<ModioModfile, T>, ?custom:T):Void {
		reqStart("GET", '/games/$gameId/mods/$mod_id/files/' + file_id);
		reqAddUserTokenOrAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#add-modfile */
	public static function addModfile<T>(mod_id:Int, fields:ModioAddModfile, fn:ModioFunc<ModioModfile, T>, ?custom:T):Void {
		reqStart("POST", '/games/$gameId/mods/$mod_id/files');
		reqAddUserToken();
		reqAddTypedef(fields);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#edit-modfile */
	public static function editModfile<T>(mod_id:Int, file_id:Int, fields:ModioEditModfile, fn:ModioFunc<ModioModfile, T>, ?custom:T):Void {
		reqStart("PUT", '/games/$gameId/mods/$mod_id/files/' + file_id);
		reqAddUserToken();
		reqAddTypedef(fields);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#delete-modfile */
	public static function deleteModfile<T>(mod_id:Int, file_id:Int, fn:ModioFunc<ModioBlank, T>, ?custom:T):Void {
		reqStart("DELETE", '/games/$gameId/mods/$mod_id/files/' + file_id);
		reqAddUserToken();
		reqSend(fn, custom);
	}
	//}
	
	//{ Media
	/** @see https://docs.mod.io/#add-game-media */
	public static function addGameMedia<T>(game_id:Int, fields:ModioAddGameMedia, fn:ModioFunc<ModioMessage, T>, ?custom:T):Void {
		reqStart("POST", '/games/$game_id/media');
		reqAddUserToken();
		reqAddTypedef(fields);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#add-mod-media */
	public static function addModMedia<T>(mod_id:Int, fields:ModioAddModMedia, fn:ModioFunc<ModioMessage, T>, ?custom:T):Void {
		reqStart("POST", '/games/$gameId/mods/$mod_id/media');
		reqAddUserToken();
		reqAddTypedef(fields);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#add-mod-media */
	public static function deleteModMedia<T>(mod_id:Int, fields:ModioDeleteModMedia, fn:ModioFunc<ModioBlank, T>, ?custom:T):Void {
		reqStart("DELETE", '/games/$gameId/mods/$mod_id/media');
		reqAddUserToken();
		reqAddTypedef(fields);
		reqSend(fn, custom);
	}
	//}
	
	//{ Subscribe
	/** @see https://docs.mod.io/#subscribe-to-mod */
	public static function subscribe<T>(mod_id:Int, fn:ModioFunc<ModioMod, T>, ?custom:T):Void {
		reqStart("POST", '/games/$gameId/mods/$mod_id/subscribe');
		reqAddUserToken();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#unsubscribe-from-mod */
	public static function unsubscribe<T>(mod_id:Int, fn:ModioFunc<ModioMod, T>, ?custom:T):Void {
		reqStart("DELETE", '/games/$gameId/mods/$mod_id/subscribe');
		reqAddUserToken();
		reqSend(fn, custom);
	}
	//}
	
	//{ Events
	/** @see https://docs.mod.io/#get-all-mod-events */
	public static function getAllModEvents<T>(game_id:Int, filters:Array<ModioFilter>, fn:ModioFunc<ModioGetModEvents, T>, ?custom:T):Void {
		reqStart("GET", '/games/$game_id/mods/events');
		reqAddUserTokenOrAppKey();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-mod-events */
	public static function getModEvents<T>(mod_id:Int, fn:ModioFunc<ModioGetModEvents, T>, ?custom:T):Void {
		reqStart("GET", '/games/$gameId/mods/$mod_id/events');
		reqAddUserTokenOrAppKey();
		reqSend(fn, custom);
	}
	//}
	
	//{ Stats
	/** @see https://docs.mod.io/#get-all-mod-events */
	public static function getAllModStats<T>(game_id:Int, filters:Array<ModioFilter>, fn:ModioFunc<ModioGetModStats, T>, ?custom:T):Void {
		reqStart("GET", '/games/$game_id/mods/stats');
		reqAddUserTokenOrAppKey();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-mod-stats */
	public static function getModStats<T>(mod_id:Int, fn:ModioFunc<ModioStats, T>, ?custom:T):Void {
		reqStart("GET", '/games/$gameId/mods/$mod_id/stats');
		reqAddUserTokenOrAppKey();
		reqSend(fn, custom);
	}
	//}
	
	// todo: Tags
	// todo: Ratings
	// todo: Metadata
	// todo: Dependencies
	// todo: Teams
	// todo: Comments
	// todo: Reports
	
	//{ Me
	/** @see https://docs.mod.io/#get-authenticated-user */
	public static function getAuthenticatedUser<T>(fn:ModioFunc<ModioUser, T>, ?custom:T):Void {
		reqStart("GET", '/me');
		reqAddUserToken();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-user-subscriptions */
	public static function getUserSubscriptions<T>(filters:Array<ModioFilter>, fn:ModioFunc<ModioGetAllMods, T>, ?custom:T):Void {
		reqStart("GET", '/me/subscribed');
		reqAddUserToken();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-user-events */
	public static function getUserEvents<T>(filters:Array<ModioFilter>, fn:ModioFunc<ModioGetUserEvents, T>, ?custom:T):Void {
		reqStart("GET", '/me/events');
		reqAddUserToken();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-user-games */
	public static function getUserGames<T>(filters:Array<ModioFilter>, fn:ModioFunc<ModioGetAllGames, T>, ?custom:T):Void {
		reqStart("GET", '/me/games');
		reqAddUserToken();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-user-mods */
	public static function getUserMods<T>(filters:Array<ModioFilter>, fn:ModioFunc<ModioGetAllMods, T>, ?custom:T):Void {
		reqStart("GET", '/me/mods');
		reqAddUserToken();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-user-modfiles */
	public static function getUserModfiles<T>(filters:Array<ModioFilter>, fn:ModioFunc<ModioGetAllModfiles, T>, ?custom:T):Void {
		reqStart("GET", '/me/files');
		reqAddUserToken();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	//}
}
