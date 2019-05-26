package modio.core;

/**
 * ...
 * @author YellowAfterlife
 */
#if gml
typedef ModioBuf = modio.core.gml.ModioBufGml;
#else
typedef ModioBuf = modio.core.std.ModioBufStd;
#end
