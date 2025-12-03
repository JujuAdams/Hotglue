// Feather disable all

/// @param asset
/// @param projectStructure

function __HotglueNodeCommon(_asset, _projectStructure) constructor
{
    __asset = _asset;
    __projectStructure = _projectStructure;
    
    static GetName = function()
    {
        return __asset.data.name;
    }
    
    static GetHotglueName = function()
    {
        return __asset.GetName();
    }
    
    static GetChildren = function()
    {
        static _emptyArray = [];
        return _emptyArray;
    }
}