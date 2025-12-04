// Feather disable all

function __InterfaceProjectViewBuildTreeAsSource()
{
    BuildTreeAsSource = method(undefined, function(_otherProject = undefined)
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
    });
    
    __BuildTreeAsSourceSweep = method(undefined, function(_node, _collisionDictionary)
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
    });
    
    __BuildTreeAsSourceInner = method(undefined, function(_node, _collisionDictionary)
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
    });
}