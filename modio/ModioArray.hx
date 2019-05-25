package modio;

/**
 * This is a typedef used in JSON responses.
 * GML uses a special type for it, whlie other platforms can stick with Array.
 * @author YellowAfterlife
 */
#if (gml)
typedef ModioArray<T> = gml.ds.ArrayList<T>;
#else
typedef ModioArray<T> = Array<T>;
#end
