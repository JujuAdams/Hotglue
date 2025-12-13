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
        
        var _pid = _node.GetPID();
        var _selected = __GetSelected(_node);
        var _children = _node.GetChildren();
        
        var _anyCollision = ((_pid != undefined) && struct_exists(_collisionDictionary, _pid));
        var _anySelected  = _selected;
        var _allSelected  = _selected || (array_length(_children) > 0);
        
        var _i = 0;
        repeat(array_length(_children))
        {
            __BuildTreeAsSourceSweep(_children[_i], _collisionDictionary);
            
            _anyCollision |= _return.__anyCollision;
            _anySelected  |= _return.__anySelected;
            _allSelected  &= _return.__allSelected;
        
            ++_i;
        }
        
        __anyCollisionDict[$ ptr(_node)] = _anyCollision;
        __anySelectedDict[$  ptr(_node)] = _anySelected;
        __allSelectedDict[$  ptr(_node)] = _allSelected;
        
        _return.__anyCollision = _anyCollision;
        _return.__anySelected  = _anySelected;
        _return.__allSelected  = _allSelected;
        
        return _return;
    });
    
    __BuildTreeAsSourceInner = method(undefined, function(_node, _collisionDictionary)
    {
        var _pid = _node.GetPID();
        
        var _collision = ((_pid != undefined) && struct_exists(_collisionDictionary, _pid));
        
        var _anyCollision = __anyCollisionDict[$ ptr(_node)];
        var _anySelected  = __anySelectedDict[$  ptr(_node)];
        var _allSelected  = __allSelectedDict[$  ptr(_node)];
        
        if (_node.__isFolder)
        {
            if (_node.__selectable)
            {
                ImGuiCheckboxFlags($"###{ptr(_node)}_selected", 2*_allSelected + _anySelected, 3);
                
                if (ImGuiIsItemClicked())
                {
                    _allSelected = not _allSelected;
                    __SetSelected(_node, _allSelected);
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
            //if (_node.__selectable && (_pid != undefined) && ImGuiIsItemClicked() && (not ImGuiIsItemToggledOpen()))
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
                ImGuiCheckbox($"###{ptr(_node)}_selected", _allSelected);
                if (ImGuiIsItemClicked())
                {
                    _allSelected = not _allSelected;
                    __SetSelected(_node, _allSelected);
                }
                
                ImGuiSameLine();
            }
            
            if (_collision) ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            ImGuiTreeNodeEx($"{_node.GetName()}##{ptr(_node)}", ImGuiTreeNodeFlags.Leaf);
            if (_collision) ImGuiPopStyleColor();
            
            if (ImGuiIsItemClicked())
            {
                _allSelected = not _allSelected;
                __SetSelected(_node, _allSelected);
            }
            
            ImGuiTreePop();
        }
    });
}