package modio;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioFunc<T, C> = (result:T, custom:C)->Void;
// I'd love to do
// typedef ModioFunc<T, C> = haxe.extern.EitherType<(result:T, custom:C)->Void, (result:T)->Void>;
// but this causes field access on result to be dynamic in AST.
