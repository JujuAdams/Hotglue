/// Feather disable all

/// Returns if an asset name doesn't exist in the game specifically because the asset has been
/// stripped during compile due to the "Automatically remove unused assets when compiling" feature.
/// This function will return `true` only if the asset exists in the project file but not at
/// runtime. This means `asset_get_stripped()` will return `false` if the asset name is simply
/// misspelled.
/// 
/// The asset name should be passed to this function as a string e.g. you should call
/// `asset_get_stripped("obj_example")` for an object named `obj_example`.
/// 
/// Please note:
/// 
/// - This function needs access to the project .yy JSON file which means this function will not
///   work when running on a device other than your development hardware (e.g. Android, iOS,
///   Nintendo Switch etc.) and will always return `false`.
/// 
/// - This function will only work when running the game from the IDE. When running from an
///   executable, this function will always return `false`. 
/// 
/// - This function requires you to untick the "Disable file system sandbox" Game Option for the
///   platform you're running on.
/// 
/// - In IDE v2024.11.0.179 / Runtime v2024.11.0.226: room assets, script assets and particle
///   system assets do not appear to get stripped by the compiler.
///     
/// - In IDE v2024.14.0.207  Runtime v2024.14.0.251: room assets and script assets do not
///   appear to get stripped by the compiler.
/// 
/// @param assetName

function asset_get_stripped(_assetName)
{
    static _projectResourceDict = (function()
    {
        if (GM_build_type != "run")
        {
            //Skip all this work if we're not running from the IDE
            return undefined;
        }
        
        if ((os_type != os_windows) && (os_type != os_macosx) && (os_type != os_linux))
        {
            //Skip all this work if we're running on a non-development platform
            return undefined;
        }
        
        if (GM_is_sandboxed)
        {
            show_error(" \nPlease tick `\"Disable file system sandbox\" for this platform in your Game Options\n ", true);
        }
        
        try
        {
            var _buffer = buffer_load(GM_project_filename);
            var _jsonString = buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);
            
            var _dictionary = {};
            
            var _resourcesArray = json_parse(_jsonString)[$ "resources"];
            var _i = 0;
            repeat(array_length(_resourcesArray))
            {
                _dictionary[$ _resourcesArray[_i].id.name] = true;
                ++_i;
            }
        }
        catch(_error)
        {
            show_debug_message(json_stringify(_error, true));
            show_error(" \nProject JSON failed to load\n ", true);
        }
        
        return _dictionary;
    })();
    
    if (GM_build_type != "run")
    {
        //We can't detect anything helpful if we're not running from the IDE
        return false;
    }
    
    if ((os_type != os_windows) && (os_type != os_macosx) && (os_type != os_linux))
    {
        //We also can't detect anything helpful if we're running on a non-development platform
        return false;
    }
    
    if (asset_get_type(_assetName) != asset_unknown)
    {
        //Asset exists in the project; definitionally not stripped
        return false;
    }
    else
    {
        //If we find the asset name in the project JSON then the asset has been stripped
        return struct_exists(_projectResourceDict, _assetName);
    }
}

show_debug_message("Thank you for using `asset_get_stripped()` by Juju Adams! This version 1.0.0, 2025-11-17.");