# modio-rest

This is a REST-based Haxe wrapper for [mod.io](https://mod.io) API. It's a little less full-featured than some of the [native wrappers](https://apps.mod.io/) (no automatic installation/in-app mod browser UI), but can do any operations that native does.

Since it's all Haxe, it can also be used to generate SDKs for toolsets without an existing native wrapper.

## Haxe notes

Aside of what will be mentioned below,

- All API functions of interest are in `modio.Modio`.
- HTTP status is stored in `Modio.status`.
- Error text is stored in `Modio.errorText`.
- Input/output JSON structures are strictly typed (see `modio.schema.*`).
- You can make use of "custom" argument in callbacks if closuring on platform(s) of interest is suboptimal.

## GML notes

GameMaker was the initial reason why this was developed so the extension accommodates using it from GM pretty well.

### Callbacks

Any extension function that performs asynchronous operations takes a callback script, and, optionally, a "custom" argument that will be passed (as `argument1`) to your script along with the result-map (`argument0`).

Inside your script you retrieve those arguments, check HTTP status (stored in `modio_status` for convenience), and act accordingly.

For example, a callback for `modio_email_exchange` might look as following:
```gml
if (modio_status == 200) { // OK!
	var tk = argmuent0[?"access_token"];
	modio_set_user_token(tk);
} else {
	// in case of failure, modio_error_text contains returned error text,
    // or, if connection to mod.io failed, just a "HTTP #" string.
	show_message("Couldn't verify the code: " + string(modio_error_text));
}
```
Depending on request, you may want to check that status is just a non-error (`modio_status < 400`) - for example, upload functions use HTTP 201 "Created".

### Setting up

- Add `modio` extension to your project by dragging and dropping the YYMP onto your workspace area (in GMS1, import the GMEZ).
- If you intend to upload mods from your game, similarly import the [ZipWriter](https://yellowafterlife.itch.io/gamemaker-zip) extension (which lets you assemble ZIP files from in-game).
- Call `modio_init` on game start. Pick the environment based on whether you are using test (`test.mod.io`) or live (`mod.io`) environment.
- Call `modio_async_http` in Async - HTTP event of a persistent object.
- At this point you can call `modio_` functions. Some require authentication (see below).

### Functions

Majority of functions directly correspond to their `mod.io` counterparts - e.g. [edit-mod](https://docs.mod.io/#edit-mod) endpoint is `modio_edit_mod(mod_id, fields_map, callback, ?custom)`;
if you open your project in [GMEdit](https://yellowafterlife.itch.io), you can right-click the extension, pick "Show API", and see associated mod.io URLs for each function.

### Types

Anything that is named "ModioSomething" is a JSON style `ds_map`. You can check mod.io documentation or ["schema" directory](https://github.com/YellowAfterlife/modio-rest/tree/master/modio/schema) in this repository for expected values (note: "ModioArray" means a `ds_list`, just like in regular JSON).

For "ModioFile" specifically, it can be either a path to the file to upload, or a 2-element array with file name (index 0) and buffer (index 1).


### Filters

Some functions accept an array of filters corresponding to [filtering parameters](https://docs.mod.io/#filtering).  
Filters can be created via extension functions starting with `modio_filter_*`.  
For filter constructors with a "ModioFilterValues" argument, you supply an array of strings or numbers.

### Email authentication flow

For performing a number of operations (uploads, downloading non-public media, etc.) you'll want to authorize the user. Doing so is as following:

- Get email address from the user
- Pass it to `modio_email_request`
- If request succeeded, ask the user for the security code they got in the email. You might show `result[?"message"]` in the prompt.
- Pass the security code to `modio_email_exchange`.
- If the request succeeded, you get `result[?"access_token"]`. Pass it to `modio_set_user_token` and, optionally, store it for later.

Then, on startup you might pull your previously stored token, pass it to `modio_set_user_token `, try doing anything with it to verify that it's still valid (`modio_get_authenticated_user` works well for this), resetting the token if that fails.

### Examples

Getting info about your game:
```
modio_get_game(modio_game_id, scr_show_game_info);

// then, in scr_show_game_info:
if (modio_status == 200) {
	show_debug_message("Name: " + argument0[?"name"]);
	show_debug_message("Summary: " + argument0[?"summary"]);
	var header = argument0[?"header"]
	show_debug_message("Header URL: " + header[?"original"]);
} else {
	show_debug_message(modio_error_text);
}
```

Creating a mod:
```
var m = ds_map_create();
m[?"logo"] = "gmcog.png";
m[?"name"] = "GML test!";
m[?"summary"] = "Ah, videogames.";
modio_add_mod(m, scr_mod_created);
ds_map_destroy(m);

// then, in scr_mod_created:
if (modio_status == 201) { // could just check <400 as per above
	global.new_mod_id = argument0[?"id"];
	show_debug_message("Created a mod!");
} else {
	show_debug_message(modio_error_text);
}
```

Adding a file to a mod:
```
// this is what you need ZipWriter for:
var z = zip_create();
zip_add_file(z, "gmcog.png", "gmcog.png");
zip_save(z, "upload.zip");
zip_destroy(z);
// here, new_mod_id was set in previous snippet:
var m = ds_map_create();
m[?"filedata"] = "upload.zip";
modio_add_modfile(global.new_mod_id, m, scr_file_added, "modio_add_modfile");
ds_map_destroy(m);

// then, in scr_file_added:
if (modio_status == 201) { // ditto
	show_debug_message("Uploaded a file!");
} else {
	show_debug_message(modio_error_text);
}
```

### Useful tools

- [ZipWriter](https://yellowafterlife.itch.io/gamemaker-zip) (for packing up ZIP files for mod uploads)
- [JSON beautifier script](https://yal.cc/gamemaker-beautifying-json/) (for looking at JSON output more comfortably)
- [Sample project](https://apps.mod.io/gamemaker-extension) (has examples for login flow, input prompts, downloader helpers)