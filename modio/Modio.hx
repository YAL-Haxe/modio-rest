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
	
	@:doc public static var gameId:Int;
	
	@:access(modio.ModioCore)
	public static function init(_environment:ModioEnvironment, _gameId:Int, _apiKey:String) {
		apiKey = _apiKey;
		environment = _environment;
		reqServer = environment == Test ? "https://api.test.mod.io/v1" : "https://api.mod.io/v1";
		gameId = _gameId;
	}
	
	/** @see https://docs.mod.io/#authentication */
	@:access(modio.ModioCore)
	public static function setUserToken(userAuthToken:String) {
		userToken = userAuthToken;
	}
	
	#if (!gml && sys)
	public static function update():Void {
		ModioCore.update();
	}
	#end
	
	//{ Auth
	
	/** @see https://docs.mod.io/#step-1-requesting-a-security-code */
	public static function emailRequest<T>(email:String, fn:ModioEmailRequest->T->Void, ?custom:T):Void {
		reqStart("POST", "/oauth/emailrequest");
		reqAdd("email", email);
		reqAddAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#step-2-exchanging-security-code-for-access-token */
	public static function emailExchange<T>(securityCode:String, fn:ModioAccessToken->T->Void, ?custom:T):Void {
		reqStart("POST", "/oauth/emailexchange");
		reqAdd("security_code", securityCode);
		reqAddAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#authenticate-via-steam */
	public static function steamAuth<T>(appdata_b64:String, fn:ModioAccessToken->T->Void, ?custom:T):Void {
		reqStart("POST", "/external/steamauth");
		reqAddAppKeyToURL();
		reqAdd("appdata", appdata_b64);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#authenticate-via-gog-galaxy */
	public static function galaxyAuth<T>(appdata_b64:String, fn:ModioAccessToken->T->Void, ?custom:T):Void {
		reqStart("POST", "/external/galaxyauth");
		reqAddAppKeyToURL();
		reqAdd("appdata", appdata_b64);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#link-external-account */
	public static function externalLink<T>(service:String, service_id:String, email:String, fn:ModioMessage->T->Void, ?custom:T):Void {
		reqStart("POST", "/external/galaxyauth");
		reqAddUserToken();
		reqAdd("service", service);
		reqAdd("service_id", service_id);
		reqAdd("email", email);
		reqSend(fn, custom);
	}
	
	//}
	
	//{
	/** @see https://docs.mod.io/#get-all-games */
	public static function getAllGames<T>(filters:Array<ModioFilter>, fn:(q:ModioGetAllGames, c:T)->Void, ?custom:T, ?sort:String):Void {
		reqStart("GET", "/games");
		reqAddAppKey();
		reqAddFilters(filters);
		if (sort != null) reqAdd("_sort", sort);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-game */
	public static function getGame<T>(game_id:Int, fn:(q:ModioGame, c:T)->Void, ?custom:T):Void {
		reqStart("GET", "/games/" + game_id);
		reqAddAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-all-mods */
	public static function getAllMods<T>(filters:Array<ModioFilter>, fn:(q:ModioGetAllMods, c:T)->Void, ?custom:T, ?sort:String):Void {
		reqStart("GET", '/games/$gameId/mods');
		reqAddAppKey();
		reqAddFilters(filters);
		if (sort != null) reqAdd("_sort", sort);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-mod */
	public static function getMod<T>(mod_id:Int, fn:(q:ModioMod, c:T)->Void, ?custom:T):Void {
		reqStart("GET", '/games/$gameId/mods/' + mod_id);
		reqAddAppKey();
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#add-mod */
	public static function addMod<T>(data:ModioAddMod, fn:(q:ModioMod, c:T)->Void, ?custom:T):Void {
		reqStart("POST", '/games/$gameId/mods');
		reqAddUserToken();
		reqAddTypedef(data);
		reqSend(fn, custom);
	}
	//}
	
	//{
	/** @see https://docs.mod.io/#get-all-modfiles */
	public static function getAllModfiles<T>(mod_id:Int, filters:Array<ModioFilter>, fn:(q:ModioGetAllModfiles, c:T)->Void, ?custom:T):Void {
		reqStart("GET", '/games/$gameId/mods/');
		reqAddAppKey();
		reqAddFilters(filters);
		reqSend(fn, custom);
	}
	
	/** @see https://docs.mod.io/#get-modfile */
	public static function getModfile<T>(mod_id:Int, file_id:Int, fn:(q:ModioModfile, c:T)->Void, ?custom:T):Void {
		reqStart("GET", '/games/$gameId/mods/$mod_id/files/' + file_id);
		reqAddAppKey();
		reqSend(fn, custom);
	}
	//}
}
