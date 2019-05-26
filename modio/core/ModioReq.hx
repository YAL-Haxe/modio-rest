package modio.core;

/**
 * ...
 * @author YellowAfterlife
 */
#if gml
typedef ModioReq = modio.core.gml.ModioReqGml;
#else
typedef ModioReq = modio.core.std.ModioReqStd;
#end
