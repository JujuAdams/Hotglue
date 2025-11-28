// Feather disable all

/// Loads a .yyp file and returns an struct constructed by `__HotglueProject`.
/// 
/// Hotglue uses the concept of an "asset reference" to unify references to different assets in a
/// project. There are three types of asset reference that Hotglue supports:
///   - `"resource:resourceName"`
///   - `"included:filePath"`
///   - `"folder:folderPath"`
/// 
/// `.GetPath()`
///   Returns the path to the .yyp project file.
/// 
/// `.GetDirectory()`
///   Returns the directory that holds the .yyp project file.
/// 
/// `.GetAssets()`
///   Return an array of asset references for all assets in a project. This will include resources,
///   folders, and included files.
/// 
/// `.ImportAllFrom(sourceProject, [subfolder=""])`
///   Imports all assets (resources, included files, folders) from the source project.
/// 
/// `.ImportFrom(sourceProject, [assetRefArray], [subfolder=""])`
///   Imports a selection of assets from the source project. The input array must contain asset
///   references (see above).
/// 
/// `.GetAssetExists(assetRef)`
///   Returns if an asset reference exists.
/// 
/// `.GetConflicting(otherProject)`
///   Returns an array of array references in the scoped project and are also found in the other
///   project.
/// 
/// `.GetNonConflicting(otherProject)`
///   Returns an array of array references in the scoped project and are not found in the other
///   project.
/// 
/// `.GetExpandedAssets(assetRefArray)`
///   Returns an array of asset references that will be imported if the input asset reference array
///   is imported. For example, if the room `rmExample` contains instances of `objExample` and uses
///   `sprExample` as a background image then the returned array will contain all three resources.
/// 
/// @param path

function HotglueLoadYYP(_yypPath)
{
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    if (not file_exists(_yypPath))
    {
        __HotglueError($"\"{_yypPath}\" doesn't exist");
    }
    
    return new __HotglueProject(_yypPath);
}