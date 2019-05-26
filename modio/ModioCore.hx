package modio;
import modio.misc.*;
import modio.enums.*;
import modio.schema.*;
import modio.enums.ModioFilter;
import modio.ModioFile;
#if (gml)
import gml.net.*;
import gml.events.*;
import gml.ds.HashTable;
import gml.io.Buffer;
#else
import haxe.Http;
import haxe.io.BytesOutput;
import haxe.Json;
#if sys
import sys.thread.Mutex;
import sys.thread.Thread;
#end
#end

/**
 * ...
 * @author YellowAfterlife
 */
class ModioCore {
	private static var environment:ModioEnvironment;
	private static var apiKey:String;
	private static var userToken:String;
	private static var reqServer:String = "https://api.mod.io/v1";
	
	private static var reqMethod:String;
	private static var reqBuf:ModioBuf = new ModioBuf();
	private static var reqFirst:Bool;
	private static var reqURL:String;
	private static var reqGET:Bool;
	private static var reqMultipart:Bool;
	private static var reqMultipartBoundary:String;
	private static var reqMultipartSeed:Int = 48271;
	#if gml
	private static var reqHeaders:HashTable<String, String> = new HashTable();
	#elseif js
	private static var reqHttp:ModioHttpJs;
	#else
	private static var reqHttp:Http;
	#end
	public static function reqStart(method:String, path:String) {
		reqFirst = true;
		reqURL = reqServer + path;
		reqMethod = method;
		reqGET = (method == "GET");
		reqMultipart = false;
		//
		#if gml
			reqBuf.rewind();
			reqHeaders.clear();
		#else
			reqBuf = new ModioBuf();
			#if js
				reqHttp = new ModioHttpJs(reqURL);
			#else
				reqHttp = new Http(reqURL);
			#end
		#end
		//
		reqSetHeader("Accept", "*/*");
		if (reqGET) {
			reqBuf.add(reqURL);
		} else {
			reqSetHeader("Content-Type", "application/x-www-form-urlencoded");
		}
	}
	
	public static function reqSetHeader(key:String, val:String) {
		#if (gml)
		reqHeaders[key] = val;
		#else
		reqHttp.setHeader(key, val);
		#end
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
		var name:String, data, ext:String;
		var cleanup = false;
		if (Std.is(file, String)) {
			#if (gml)
				data = Buffer.load(file);
				data.position = data.size;
				name = SfTools.raw("filename_name")(file);
				cleanup = true;
			#elseif (sys)
				data = sys.io.File.getBytes(file);
				name = haxe.io.Path.withoutDirectory(file);
			#else
				throw "Please provide a file pair on non-sys";
			#end
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
		#if (gml)
		ext = SfTools.raw("filename_ext")(file); // (...GML has built-in path functions)
		#else
		ext = haxe.io.Path.extension(file);
		#end
		var mime = ModioMimetypes.get(ext);
		trace(mime);
		reqBuf.add(mime); // todo: do we care?
		reqBuf.add('\r\n\r\n');
		reqBuf.addData(data);
		#if (gml)
		if (cleanup) data.destroy();
		#end
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
		#if !gml
		inline function failure(x:Dynamic, status:Int):ModioResponse {
			return {
				error: {
					code: status < 0 ? 500 : status,
					message: Std.string(x)
				}
			};
		}
		inline function parse(s:String):Dynamic {
			if (s == "") {
				return {};
			} else try {
				return Json.parse(s);
			} catch (x:Dynamic) {
				return failure("[Invalid JSON] " + x, 500);
			}
		}
		#end
		#if (gml)
			// GML uses an async events instead of callbacks so we accomodate that
			// (and the user calls modio_async_http from Async - HTTP event somewhere)
			var id:HTTP;
			if (reqGET) {
				reqURL = reqBuf.toString();
				id = HTTP.get(reqURL);
			} else {
				if (reqMultipart) {
					(reqBuf:Buffer).savePart("body.bin", 0, reqBuf.length);
					sys.io.File.saveContent('headers.txt', reqHeaders.toString());
				}
				// required for HTTP.request to transmit payload with 0-bytes correctly
				reqSetHeader("Content-Length", Std.string(reqBuf.length));
				id = HTTP.request(reqURL, reqMethod, reqHeaders, (reqBuf:Buffer));
			}
			httpMap[id] = { func: fn, custom: custom };
		#elseif (sys)
			var pair = new ModioHTTP(fn, custom);
			httpMutex.acquire();
			httpList.push(pair);
			httpMutex.release();
			var http = reqHttp;
			inline function procTh(fn:Void->Void):Void {
				Thread.create(fn);
				//fn(); // synchronous for debugging
			}
			procTh(function() {
				var out = new BytesOutput();
				var status = -1;
				var read = true;
				var isGET = reqGET;
				http.onStatus = function(i) status = i;
				if (isGET) {
					http.url = reqBuf.toString();
					http.onError = function(e) {
						read = false;
						var r = failure(e, status);
						httpMutex.acquire();
						pair.status = status;
						pair.result = r;
						httpMutex.release();
					};
					http.onData = function(s:String) {
						var r = parse(s);
						httpMutex.acquire();
						pair.status = status;
						pair.result = r;
						httpMutex.release();
					};
					http.request(false);
				} else {
					var eresult = null;
					http.onError = function(e) {
						read = false;
						eresult = failure(e, status);
					};
					//
					var body = reqBuf.toString();
					http.setPostData(body);
					http.customRequest(true, out, null, reqMethod);
					// customRequest doesn't call onData,
					// instead synchronously writing to Output (arg.)
					var b = out.getBytes();
					var s = b.getString(0, b.length);
					var r:Dynamic;
					if (s == "" && eresult != null) {
						r = eresult;
					} else r = parse(s);
					httpMutex.acquire();
					pair.status = status;
					pair.result = r;
					httpMutex.release();
				}
			});
		#else
			var http = reqHttp;
			#if js
			http.async = true;
			#end
			var status = -1;
			http.onStatus = function(i) status = i;
			http.onError = function(e) {
				var result = parse(http.responseData);
				reqInvoke(fn, result, custom, status);
			};
			http.onData = function(s) {
				Modio.status = status;
				var result = parse(s);
				reqInvoke(fn, result, custom, status);
			};
			if (reqGET) {
				http.url = reqBuf.toString();
				http.request(false);
			} else {
				reqHttp.setPostData(reqBuf.toString());
				#if js
				reqHttp.requestWithMethod(reqMethod);
				#else
				if (reqMethod == "POST") {
					reqHttp.request(true);
				} else {
					throw "This platform only has plain haxe Http, and that doesn't support non-GET/POST requests.";
				}
				#end
			}
		#end
	}
	
	public static inline function reqInvoke<T,C>(func:ModioFunc<T,C>, result:T, custom:C, httpStatus:Int):Void {
		Modio.status = httpStatus;
		func(result, custom);
	}
	#if gml
	private static var httpMap:HashTable<HTTP, ModioHTTP> = new HashTable();
	@:expose("modio_async_http") public static function httpEventHandler() {
		var e = AsyncEvent.http;
		var req = httpMap[e.id];
		if (req == null) return;
		if (e.status == Progress) return;
		httpMap.remove(e.id);
		// hack: sfgml doesn't know if you want `this` to be passed to function or not,
		// but here we do not want that, so we'll cast to a non-field function.
		var fn:Dynamic->Dynamic->Void = req.func;
		var json:HashTable<String, Dynamic>;
		if (e.result != null) {
			json = HashTable.parse(e.result);
			if (json == HashTable.defValue) json = new HashTable();
		} else {
			json = new HashTable();
			var error = new HashTable<String, Dynamic>();
			error["code"] = e.httpStatus;
			error["message"] = "HTTP " + e.httpStatus;
			json["code"] = e.httpStatus;
			json.addMap("error", error);
		}
		reqInvoke(fn, json, req.custom, e.httpStatus);
		json.destroy();
	}
	#elseif sys
	private static var httpMutex:Mutex = {
		var m = new Mutex();
		m.release();
		return m;
	};
	private static var httpList:Array<ModioHTTP> = [];
	public static function update() {
		httpMutex.acquire();
		var l = httpList;
		var i = 0;
		var n = l.length;
		while (i < n) {
			var q = l[i];
			if (q.result != null) {
				reqInvoke(q.func, q.result, q.custom, q.status);
				l.splice(i, 1);
				n--;
			} else i++;
		}
		httpMutex.release();
	}
	#end
}
#if gml
@:nativeGen private typedef ModioHTTP = {
	func:Dynamic->Dynamic->Void,
	custom:Dynamic
}
@:forward(rewind)
private abstract ModioBuf(Buffer) to Buffer {
	public var length(get, never):Int;
	private inline function get_length() {
		return this.position;
	}
	public inline function new() {
		this = new gml.io.Buffer(1024, Grow, 1);
	}
	public inline function add(s:String):Void {
		this.writeChars(s);
	}
	public inline function addData(b:gml.io.Buffer) {
		this.writeBufferExt(b, 0, b.position);
	}
	public inline function addChar(c:Int):Void {
		this.writeByte(c);
	}
	public inline function toString():String {
		this.writeByte(0);
		this.rewind();
		return this.readString();
	}
}
#else
#if sys
private class ModioHTTP {
	public var result:Dynamic = null;
	public var func:Dynamic->Dynamic->Void;
	public var status:Int = -1;
	public var custom:Dynamic;
	public function new(f:Dynamic->Dynamic->Void, c:Dynamic) {
		func = f;
		custom = c;
	}
}
#end
@:forward(length)
private abstract ModioBuf(BytesOutput) {
	public inline function new() {
		this = new BytesOutput();
	}
	public inline function add(s:String):Void {
		this.writeString(s);
	}
	public inline function addData(b:haxe.io.Bytes) {
		this.writeBytes(b, 0, b.length);
	}
	public inline function addChar(c:Int) {
		this.writeByte(c);
	}
	public inline function toBytes() {
		return this.getBytes();
	}
	public function toString() {
		var b = this.getBytes();
		return b.getString(0, b.length);
	}
}
#end
