// Feather disable all

/// @param projectStructure

function __HotglueNodeProjectRoot(_projectStructure) : __HotglueNodeCommon(undefined, _projectStructure) constructor
{
    static __isFolder = true;
    static __selectable = false;
    
    __children = [];
    
    static GetName = function()
    {
        return "<root>";
    }
    
    static GetHotglueName = function()
    {
        return undefined;
    }
    
    static __Add = function(_node)
    {
        array_push(__children, _node);
    }
    
    static __Clear = function()
    {
        array_resize(__children, 0);
    }
    
    static GetChildren = function()
    {
        return __children;
    }
    
    static __EnsureFolder = function(_name)
    {
        if (_name == "")
        {
            return self;
        }
        
        var _childrenArray = __children;
        var _i = 0;
        repeat(array_length(_childrenArray))
        {
            if (_childrenArray[_i].__asset.data.name == _name)
            {
                return _childrenArray[_i];
            }
            
            ++_i;
        }
        
        var _hotglueName = $"folder:{_name}";
        var _quickAssetDict = __projectStructure.__project.__quickAssetDict;
        
        var _asset = _quickAssetDict[$ _hotglueName];
        if (not is_struct(_asset))
        {
            __HotglueError($"Failed to find asset for \"{_hotglueName}\"");
        }
        
        var _node = new __HotglueNodeProjectFolder(_asset, __projectStructure);
        __Add(_node);
        
        return _node;
    }
}