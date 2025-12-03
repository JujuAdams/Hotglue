// Feather disable all

/// @param project

function ClassInterfaceProjectView(_project) constructor
{
    __project = _project;
    
    __selectedDict     = {};
    __prevAnyCollision = {};
    __prevAnySelected  = {};
    
    static Build = function()
    {
        var _quickAssetArray = __project.__quickAssetArray;
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            ImGuiText(_quickAssetArray[_i].name);
            ++_i;
        }
    }
    
    static BuildAsSource = function(_otherProject = undefined)
    {
        var _projectStructure = __project.GetProjectStructure();
        if (_projectStructure == undefined)
        {
            ImGuiText($"Project structure rebuilding, please wait... ({100*__project.__structure.GetRebuildingProgress()}%%)");
            return;
        }
        
        var _collisionDictionary = (_otherProject == undefined)? {} : _otherProject.__quickAssetDict;
        
        __BuildAsSourceInner(_projectStructure.__rootNode, _collisionDictionary);
        __BuildAsSourceInner(_projectStructure.__includedFilesNode, _collisionDictionary);
    }
    
    static __GetSelected = function(_node)
    {
        return struct_exists(__selectedDict, _node.GetHotglueName());
    }
    
    static __SetSelected = function(_node, _state)
    {
        if (_state)
        {
            __selectedDict[$ _node.GetHotglueName()] = true;
        }
        else
        {
            struct_remove(__selectedDict, _node.GetHotglueName());
        }
        
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
    }
    
    static __BuildAsSourceInner = function(_node, _collisionDictionary)
    {
        static _return = {};
        
        var _anyCollision = false;
        var _anySelected  = false;
        
        var _selected = __GetSelected(_node);
        
        var _hotglueName = _node.GetHotglueName();
        var _collision = ((_hotglueName != undefined) && struct_exists(_collisionDictionary, _hotglueName));
        
        if (_node.__selectable)
        {
            ImGuiCheckbox($"###{ptr(_node)}_selected", struct_exists(__selectedDict, _hotglueName));
            
            if (ImGuiIsItemClicked())
            {
                _selected = not _selected;
                __SetSelected(_node, _selected);
            }
            
            ImGuiSameLine();
        }
        else
        {
            ImGuiDummy(0, 18);
            ImGuiSameLine();
        }
        
        if (_node.__isFolder)
        {
            var _popColor = false;
            
            if (_collision)
            {
                ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
                _popColor = true;
            }
            else if (__prevAnyCollision[$ ptr(_node)] ?? false)
            {
                ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_ORANGE_TEXT, 1);
                _popColor = true;
            }
            
            var _open = ImGuiTreeNode($"{_node.GetName()}##{ptr(_node)}");
            if (_popColor) ImGuiPopStyleColor();
            
            //var _open = ImGuiTreeNodeEx($"{_node.GetName()}##{ptr(_node)}", ImGuiTreeNodeFlags.OpenOnArrow | ImGuiTreeNodeFlags.OpenOnDoubleClick);
            //if (_node.__selectable && (_hotglueName != undefined) && ImGuiIsItemClicked() && (not ImGuiIsItemToggledOpen()))
            //{
            //    
            //}
            
            if (_open)
            {
                var _children = _node.GetChildren();
                if (array_length(_children) <= 0)
                {
                    ImGuiPushStyleColor(ImGuiCol.Text, c_gray, 1);
                    ImGuiText("(empty)");
                    ImGuiPopStyleColor();
                }
                else
                {
                    var _i = 0;
                    repeat(array_length(_children))
                    {
                        __BuildAsSourceInner(_children[_i], _collisionDictionary);
                        
                        _anyCollision |= _return.__collision;
                        _anySelected  |= _return.__selected;
        
                        ++_i;
                    }
                }
                
                ImGuiTreePop();
            }
        }
        else
        {
            if (_collision) ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            ImGuiTreeNodeEx($"{_node.GetName()}##{ptr(_node)}", ImGuiTreeNodeFlags.Leaf);
            
            if (ImGuiIsItemClicked())
            {
                _selected = not _selected;
                __SetSelected(_node, _selected);
            }
            
            if (_collision) ImGuiPopStyleColor();
            
            ImGuiTreePop();
        }
        
        _anyCollision |= _collision;
        _anySelected  |= __GetSelected(_node);
        
        _return.__collision = _anyCollision;
        _return.__selected  = _anySelected;
        
        if (_node.__isFolder)
        {
            __prevAnyCollision[$ ptr(_node)] = _anyCollision;
            __prevAnySelected[$  ptr(_node)] = _anySelected;
        }
        
        return _return;
    }
    
    static BuildAsDestination = function(_comparisonData = undefined)
    {
        var _projectStructure = __project.GetProjectStructure();
        if (_projectStructure == undefined)
        {
            ImGuiText($"Project structure rebuilding, please wait... ({100*__project.__structure.GetRebuildingProgress()}%%)");
            return;
        }
        
        if (is_struct(_comparisonData))
        {
            var _collisionDictionary = _comparisonData.__quickAssetDict;
        }
        else
        {
            var _collisionDictionary = {};
            
            if (is_array(_comparisonData))
            {
                var _i = 0;
                repeat(array_length(_comparisonData))
                {
                    _collisionDictionary[$ $"resource:{_comparisonData[_i].__file.GetName()}"] = true;
                    ++_i;
                }
            }
        }
        
        __BuildTreeAsDestinationInner(_projectStructure.__rootNode, _collisionDictionary);
        __BuildTreeAsDestinationInner(_projectStructure.__includedFilesNode, _collisionDictionary);
    }
    
    static __BuildTreeAsDestinationInner = function(_node, _collisionDictionary)
    {
        var _hotglueName = _node.GetHotglueName();
        var _collision = ((_hotglueName != undefined) && struct_exists(_collisionDictionary, _hotglueName));
        
        if (_node.__isFolder)
        {
            if (_collision) ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            var _open = ImGuiTreeNodeEx($"{_node.GetName()}##{ptr(_node)}", ImGuiTreeNodeFlags.OpenOnArrow | ImGuiTreeNodeFlags.OpenOnDoubleClick);
            if (_collision) ImGuiPopStyleColor();
            
            if (_open)
            {
                var _children = _node.GetChildren();
                if (array_length(_children) <= 0)
                {
                    ImGuiPushStyleColor(ImGuiCol.Text, c_gray, 1);
                    ImGuiText("(empty)");
                    ImGuiPopStyleColor();
                }
                else
                {
                    var _i = 0;
                    repeat(array_length(_children))
                    {
                        __BuildTreeAsDestinationInner(_children[_i], _collisionDictionary);
                        ++_i;
                    }
                }
                
                ImGuiTreePop();
            }
        }
        else
        {
            if (_collision) ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            ImGuiTreeNodeEx($"{_node.GetName()}##{ptr(_node)}", ImGuiTreeNodeFlags.Leaf);
            if (_collision) ImGuiPopStyleColor();
            
            ImGuiTreePop();
        }
    }
}