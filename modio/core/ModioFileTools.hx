package modio.core;

/**
 * ...
 * @author YellowAfterlife
 */
#if gml
typedef ModioFileTools = modio.core.gml.ModioFileToolsGml;
#else
typedef ModioFileTools = modio.core.std.ModioFileToolsStd;
#end
