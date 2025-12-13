// Feather disable all

/// @param projectStructure

function __HotglueNodeIncludedFilesRoot(_projectStructure) : __HotglueNodeCommon(undefined, _projectStructure) constructor
{
    static __isFolder = true;
    
    __children = [];
    
    static GetName = function()
    {
        return "<included files>";
    }
    
    static GetPID = function()
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
        if (_name == "datafiles")
        {
            return self;
        }
        
        var _childrenArray = __children;
        var _i = 0;
        repeat(array_length(_childrenArray))
        {
            if (_childrenArray[_i].GetName() == _name)
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