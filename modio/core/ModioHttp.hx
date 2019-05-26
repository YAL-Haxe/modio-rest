package modio.core;

/**
 * ...
 * @author YellowAfterlife
 */
#if js
typedef ModioHttp = modio.core.std.ModioHttpJs;
#else
typedef ModioHttp = haxe.Http;
#end
