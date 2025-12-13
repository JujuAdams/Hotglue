// Feather disable all

/// @param project

function ClassInterfaceProjectView(_project) constructor
{
    __project = _project;
    
    __selectedDict     = {};
    __anyCollisionDict = {};
    __anySelectedDict  = {};
    __allSelectedDict  = {};
    
    static GetSelectedCount = function()
    {
        return struct_names_count(__selectedDict);
    }
    
    static GetAssetArray = function()
    {
        var _pidArray = [];
        var _selectedDict = __selectedDict;
        
        var _keyArray = struct_get_names(_selectedDict);
        var _i = 0;
        repeat(array_length(_keyArray))
        {
            var _node = _selectedDict[$ _keyArray[_i]];
            
            var _asset = _node.__asset;
            if (_asset != undefined)
            {
                array_push(_pidArray, _asset.GetName());
            }
            
            ++_i;
        }
        
        return _pidArray;
    }
    
    static __GetSelected = function(_node)
    {
        return struct_exists(__selectedDict, ptr(_node));
    }
    
    static __SetSelected = function(_node, _state)
    {
        if (_node.__isFolder)
        {
            var _children = _node.GetChildren();
            var _i = 0;
            repeat(array_length(_children))
            {
                __SetSelected(_children[_i], _state);
                ++_i;
            }
        }
        else
        {
            if (_state)
            {
                __selectedDict[$ ptr(_node)] = _node;
            }
            else
            {
                struct_remove(__selectedDict, ptr(_node));
            }
        }
    }
    
    with(static_get(self))
    {
        __InterfaceProjectViewBuildOverview();
        __InterfaceProjectViewBuildTreeAsSource();
        __InterfaceProjectViewBuildTreeAsDestination();
    }
}