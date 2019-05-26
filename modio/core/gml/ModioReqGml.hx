package modio.core.gml;
import gml.net.*;
import gml.events.*;
import gml.ds.HashTable;
import gml.io.Buffer;
import modio.ModioCore.*;

/**
 * ...
 * @author YellowAfterlife
 */
@:access(modio.ModioCore)
class ModioReqGml {
	private static var reqHeaders:HashTable<String, String> = new HashTable();
	
	public static inline function start() {
		ModioCore.reqBuf.rewind();
	}
	
	public static inline function setHeader(field:String, val:String):Void {
		reqHeaders[field] = val;
	}
	
	public static inline function send<J,C>(fn:(json:J, custom:C)->Void, custom:C):Void {
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
	}
	
	private static var httpMap:HashTable<HTTP, ModioHTTP> = new HashTable();
	@:expose("modio_async_http") public static inline function httpEventHandler() {
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
}

@:nativeGen private typedef ModioHTTP = {
	func:Dynamic->Dynamic->Void,
	custom:Dynamic
}
