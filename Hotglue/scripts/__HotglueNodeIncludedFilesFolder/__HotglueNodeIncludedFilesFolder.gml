// Feather disable all

/// @param name
/// @param projectStructure

function __HotglueNodeIncludedFilesFolder(_name, _projectStructure) : __HotglueNodeCommon(undefined, _projectStructure) constructor
{
    static __isFolder = true;
    static __selectable = false;
    
    __name = _name;
    
    __children = [];
    
    static GetName = function()
    {
        return __name;
    }
    
    static GetPID = function()
    {
        return undefined;
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
            if (_childrenArray[_i].__name == _name)
            {
                return _childrenArray[_i];
            }
            
            ++_i;
        }
        
        var _node = new __HotglueNodeProjectFolder(_name, __projectStructure);
        __Add(_node);
        
        return _node;
    }
}