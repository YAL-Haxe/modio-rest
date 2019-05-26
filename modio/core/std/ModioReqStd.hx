package modio.core.std;
import modio.ModioCore.*;
import modio.schema.*;
import haxe.Json;
#if (sys && target.threaded)
import sys.thread.Mutex;
import sys.thread.Thread;
#end

/**
 * ...
 * @author YellowAfterlife
 */
@:access(modio.ModioCore)
class ModioReqStd {
	private static var reqHttp:ModioHttp;
	public static inline function start() {
		reqBuf = new ModioBuf();
		reqHttp = new ModioHttp(reqURL);
	}
	public static inline function setHeader(field:String, val:String):Void {
		reqHttp.setHeader(field, val);
	}
	public static inline function send<J,C>(fn:(json:J, custom:C)->Void, custom:C):Void {
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
		#if (sys && target.threaded)
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
				var out = new haxe.io.BytesOutput();
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
	#if (sys && target.threaded)
	private static var httpMutex:Mutex = { var mtx = new Mutex(); mtx.release(); mtx; };
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
#if (sys && target.threaded)
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
