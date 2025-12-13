// Feather disable all

/// @param asset
/// @param projectStructure

function __HotglueNodeCommon(_asset, _projectStructure) constructor
{
    static __isFolder = false;
    static __selectable = true;
    
    __asset = _asset;
    __projectStructure = _projectStructure;
    
    static GetName = function()
    {
        return __asset.data.name;
    }
    
    static GetPID = function()
    {
        return __asset.GetPID();
    }
    
    static GetChildren = function()
    {
        static _emptyArray = [];
        return _emptyArray;
    }
}