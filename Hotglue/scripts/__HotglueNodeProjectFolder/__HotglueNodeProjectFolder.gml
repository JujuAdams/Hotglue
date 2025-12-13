// Feather disable all

/// @param asset
/// @param projectStructure

function __HotglueNodeProjectFolder(_asset, _projectStructure) : __HotglueNodeCommon(_asset, _projectStructure) constructor
{
    static __isFolder = true;
    
    __children = [];
    
    static __Add = function(_node)
    {
        array_push(__children, _node);
    }
    
    static GetChildren = function()
    {
        return __children;
    }
    
    static __EnsureFolder = function(_name)
    {
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
        
        var _pid = $"folder:{__asset.__friendlyPath}/{_name}";
        var _quickAssetDict = __projectStructure.__project.__quickAssetDict;
        
        var _asset = _quickAssetDict[$ _pid];
        if (not is_struct(_asset))
        {
            __HotglueError($"Failed to find asset for \"{_pid}\"");
        }
        
        var _node = new __HotglueNodeProjectFolder(_asset, __projectStructure);
        __Add(_node);
        
        return _node;
    }
}