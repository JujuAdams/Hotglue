// Feather disable all

/// @param project

function ClassInterfaceProjectView(_project) constructor
{
    __project = _project;
    
    __selectedDict     = {};
    __anyCollisionDict = {};
    __anySelectedDict  = {};
    
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
    
    static __GetSelected = function(_node)
    {
        return struct_exists(__selectedDict, ptr(_node));
    }
    
    static __SetSelected = function(_node, _state)
    {
        if (_state)
        {
            __selectedDict[$ ptr(_node)] = _node;
        }
        else
        {
            struct_remove(__selectedDict, ptr(_node));
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
    
    static BuildTreeAsSource = function(_otherProject = undefined)
    {
        var _projectStructure = __project.GetProjectStructure();
        if (_projectStructure == undefined)
        {
            ImGuiText($"Project structure rebuilding, please wait... ({100*__project.__structure.GetRebuildingProgress()}%%)");
            return;
        }
        
        var _collisionDictionary = (_otherProject == undefined)? {} : _otherProject.__quickAssetDict;
        
        __BuildTreeAsSourceSweep(_projectStructure.__rootNode, _collisionDictionary);
        __BuildTreeAsSourceSweep(_projectStructure.__includedFilesNode, _collisionDictionary);
        
        __BuildTreeAsSourceInner(_projectStructure.__rootNode, _collisionDictionary);
        __BuildTreeAsSourceInner(_projectStructure.__includedFilesNode, _collisionDictionary);
    }
    
    static __BuildTreeAsSourceSweep = function(_node, _collisionDictionary)
    {
        static _return = {};
        
        var _hotglueName = _node.GetHotglueName();
        
        var _anyCollision = false;
        var _anySelected  = false;
        
        var _children = _node.GetChildren();
        var _i = 0;
        repeat(array_length(_children))
        {
            __BuildTreeAsSourceSweep(_children[_i], _collisionDictionary);
            
            _anyCollision |= _return.__anyCollision;
            _anySelected  |= _return.__anySelected;
        
            ++_i;
        }
        
        __anyCollisionDict[$ ptr(_node)] = _anyCollision;
        __anySelectedDict[$  ptr(_node)] = _anySelected;
        
        _return.__anyCollision = _anyCollision | ((_hotglueName != undefined) && struct_exists(_collisionDictionary, _hotglueName));
        _return.__anySelected  = _anySelected  | __GetSelected(_node);
        
        return _return;
    }
    
    static __BuildTreeAsSourceInner = function(_node, _collisionDictionary)
    {
        var _hotglueName = _node.GetHotglueName();
        
        var _collision = ((_hotglueName != undefined) && struct_exists(_collisionDictionary, _hotglueName));
        var _selected  = __GetSelected(_node);
        
        var _anyCollision = __anyCollisionDict[$ ptr(_node)];
        var _anySelected  = __anySelectedDict[$  ptr(_node)];
        
        if (_node.__isFolder)
        {
            if (_node.__selectable)
            {
                ImGuiCheckboxFlags($"###{ptr(_node)}_selected", _anySelected + 2*_selected, 3);
                
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
            
            var _popColor = false;
            
            if (_collision)
            {
                ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
                _popColor = true;
            }
            else if (_anyCollision)
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
                        __BuildTreeAsSourceInner(_children[_i], _collisionDictionary);
                        ++_i;
                    }
                }
                
                ImGuiTreePop();
            }
        }
        else
        {
            if (_node.__selectable)
            {
                ImGuiCheckbox($"###{ptr(_node)}_selected", _selected);
                if (ImGuiIsItemClicked())
                {
                    _selected = not _selected;
                    __SetSelected(_node, _selected);
                }
                
                ImGuiSameLine();
            }
            
            if (_collision) ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            ImGuiTreeNodeEx($"{_node.GetName()}##{ptr(_node)}", ImGuiTreeNodeFlags.Leaf);
            if (_collision) ImGuiPopStyleColor();
            
            if (ImGuiIsItemClicked())
            {
                _selected = not _selected;
                __SetSelected(_node, _selected);
            }
            
            ImGuiTreePop();
        }
    }
    
    static BuildTreeAsDestination = function(_comparisonData = undefined)
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