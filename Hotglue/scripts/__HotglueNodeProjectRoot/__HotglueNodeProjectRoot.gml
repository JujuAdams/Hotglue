// Feather disable all

/// @param projectStructure

function __HotglueNodeProjectRoot(_projectStructure) : __HotglueNodeCommon(undefined, _projectStructure) constructor
{
    __children = [];
    
    static GetName = function()
    {
        return "<root>";
    }
    
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
        
        var _hotglueName = $"folder:{_name}";
        var _quickAssetDict = __projectStructure.__project.__quickAssetDict;
        var _asset = _quickAssetDict[$ _hotglueName];
        
        var _node = new __HotglueNodeProjectFolder(_asset, __projectStructure);
        __Add(_node);
        
        return _node;
    }
}