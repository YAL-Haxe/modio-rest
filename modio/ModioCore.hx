package modio;
import modio.misc.*;
import modio.enums.*;
import modio.schema.*;
import modio.core.*;
import modio.enums.ModioFilter;
import modio.ModioFile;

/**
 * Helpers for building out requests.
 * @author YellowAfterlife
 */
class ModioCore {
	private static var environment:ModioEnvironment;
	private static var apiKey:String = null;
	private static var userToken:String = null;
	private static var reqServer:String = "https://api.mod.io/v1";
	
	private static var reqMethod:String;
	private static var reqBuf:ModioBuf = new ModioBuf();
	private static var reqFirst:Bool;
	private static var reqURL:String;
	private static var reqGET:Bool;
	private static var reqMultipart:Bool;
	private static var reqMultipartBoundary:String;
	private static var reqMultipartSeed:Int = 48271;
	
	public static function reqStart(method:String, path:String) {
		reqFirst = true;
		reqURL = reqServer + path;
		reqMethod = method;
		reqGET = (method == "GET");
		reqMultipart = false;
		ModioReq.start();
		reqSetHeader("Accept", "*/*");
		if (reqGET) {
			reqBuf.add(reqURL);
		} else {
			reqSetHeader("Content-Type", "application/x-www-form-urlencoded");
		}
	}
	
	public static function reqSetHeader(field:String, val:String) {
		ModioReq.setHeader(field, val);
	}
	
	/** Adds a parameter pair to request (into URL for GET, into body for rest) */
	public static function reqAdd(key:String, val:Any) {
		var vs:String = Std.string(val);
		if (reqMultipart) {
			reqBuf.add(reqMultipartBoundary);
			reqBuf.add('\r\nContent-Disposition: form-data; name="');
			reqBuf.add(key);
			reqBuf.add('"\r\n\r\n');
			reqBuf.add(vs);
		} else { // GET or urlencoded
			if (reqFirst) {
				if (reqGET) reqBuf.addChar("?".code);
				reqFirst = false;
			} else reqBuf.addChar("&".code);
			reqBuf.add(key);
			reqBuf.addChar("=".code);
			reqBuf.add(StringTools.urlEncode(vs));
		}
	}
	public static function reqAddBool(key:String, val:Null<Bool>) {
		if (val != null) reqAdd(key, val ? "true" : "false");
	}
	
	/** Adds a parameter pair for the API key */
	public static inline function reqAddAppKey() {
		reqAdd("api_key", apiKey);
	}
	
	/** This is only used a few times in otherwise POST-only endpoints */
	public static inline function reqAddAppKeyToURL() {
		reqURL += "?api_key=" + StringTools.urlEncode(apiKey);
	}
	
	public static inline function reqAddUserToken() {
		reqSetHeader('Authorization', 'Bearer ' + userToken);
	}
	
	/** Adds a user token, or an API key if no token was provided */
	public static inline function reqAddUserTokenOrAppKey() {
		if (userToken != null) {
			reqAddUserToken();
		} else reqAddAppKey();
	}
	
	static var reqMultipartBoundaryChars:String = modio.__macro.ModioMacro.reqMultipartBoundaryCharsGen();
	/**
	 * Switches the request into multipart/form-data mode.
	 * This should be done before you add any fields, else body will be malformed.
	 * (doing reqAddFile before other fields will also work)
	 */
	public static function reqSetMultipart() {
		if (!reqMultipart) {
			reqMultipart = true;
			var b = "--modio-";
			var seed:Float = reqMultipartSeed;
			var cs = reqMultipartBoundaryChars;
			var cn:Float = cs.length;
			for (_ in 0 ... 61) {
				// neko is acting weirdly if I leave these as int literals
				seed = Std.int((seed * 48271.) % 2147483647.);
				b += cs.charAt(Std.int(seed * (cn / 2147483647.)));
			}
			reqMultipartSeed = Std.int(seed);
			reqSetHeader("Content-Type", "multipart/form-data; boundary=" + StringTools.urlEncode(b));
			reqMultipartBoundary = "\r\n--" + b;
		}
	}
	public static function reqAddFile(key:String, file:ModioFile):Void {
		if (!reqMultipart) reqSetMultipart();
		var name:String, data;
		var cleanup = false;
		if (Std.is(file, String)) {
			data = ModioFileTools.load(file);
			name = ModioFileTools.getName(file);
			cleanup = true;
		} else {
			var pair:ModioFilePair = file;
			data = pair.data;
			name = pair.name;
		}
		reqBuf.add(reqMultipartBoundary);
		reqBuf.add('\r\nContent-Disposition: form-data; name="');
		reqBuf.add(StringTools.urlEncode(key));
		reqBuf.add('"; filename="');
		reqBuf.add(StringTools.urlEncode(name));
		reqBuf.add('"\r\nContent-Type: ');
		var ext = ModioFileTools.getExt(file);
		var mime = ModioMimetypes.get(ext);
		reqBuf.add(mime); // todo: do we care?
		reqBuf.add('\r\n\r\n');
		reqBuf.addData(data);
		if (cleanup) ModioFileTools.cleanup(data);
	}
	
	public static function reqAddFilters(fts:Array<ModioFilter>) {
		inline function reqAddWrap(k:String, v:ModioFilterValue):Void {
			reqAdd(StringTools.urlEncode(k), Std.string(v));
		}
		for (ft in fts) switch (ft) {
			case FullText(s): reqAdd("_q", s);
			case Equal(f, v): reqAddWrap(f, v);
			case NotEqual(f, v): reqAddWrap(f + "-not", v);
			case Like(f, v): reqAddWrap(f + "-lk", v);
			case NotLike(f, v): reqAddWrap(f + "-not-lk", v);
			case In(f, w): reqAddWrap(f + "-in", w.join(","));
			case NotIn(f, w): reqAddWrap(f + "-not-in", w.join(","));
			case Max(f, v): reqAddWrap(f + "-max", v);
			case Min(f, v): reqAddWrap(f + "-min", v);
			case GreaterThan(f, v): reqAddWrap(f + "-gt", v);
			case SmallerThan(f, v): reqAddWrap(f + "-st", v);
			case BitwiseAnd(f, k): reqAddWrap(f + "-bitwise-and", k);
		}
	}
	
	public static function reqSend<J,C>(fn:(json:J, custom:C)->Void, custom:C):Void {
		if (reqMultipart) {
			reqBuf.add(reqMultipartBoundary);
			reqBuf.add('--\r\n');
		}
		ModioReq.send(fn, custom);
	}
	
	public static inline function reqInvoke<T,C>(func:ModioFunc<T,C>, result:T, custom:C, httpStatus:Int):Void {
		Modio.status = httpStatus;
		var response:ModioResponse = cast result;
		var errorText = response.error != null ? response.error.message : null;
		if (httpStatus >= 400 && errorText == null) errorText = "HTTP " + httpStatus;
		Modio.errorText = errorText;
		func(result, custom);
	}
}
