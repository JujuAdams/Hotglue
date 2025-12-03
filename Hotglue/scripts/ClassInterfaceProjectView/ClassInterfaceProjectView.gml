// Feather disable all

/// @param project

function ClassInterfaceProjectView(_project) constructor
{
    __project = _project;
    
    __selectedDict = {};
    
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
        
        var _otherQuickAssetDict = (_otherProject == undefined)? {} : _otherProject.__quickAssetDict;
        
        var _quickAssetArray = __project.__quickAssetArray;
        var _selectedDict = __selectedDict;
        
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            var _asset = _quickAssetArray[_i];
            if (_asset.type != "folder")
            {
                var _assetName = _asset.name;
                
                var _old = variable_struct_exists(_selectedDict, _assetName);
                var _new = ImGuiCheckbox($"###asset{_i}", _old);
                if (_new != _old)
                {
                    if (_new)
                    {
                        _selectedDict[$ _assetName] = true;
                    }
                    else
                    {
                        variable_struct_remove(_selectedDict, _assetName);
                    }
                }
                
                ImGuiSameLine();
                
                if (variable_struct_exists(_otherQuickAssetDict, _assetName))
                {
                    ImGuiTextColored(_assetName, INTERFACE_COLOR_RED_TEXT);
                }
                else
                {
                    ImGuiText(_assetName);
                }
            }
            
            ++_i;
        }
    }
    
    static __BuildTree = function(_node, _collisionDictionary)
    {
        var _hotglueName = _node.GetHotglueName();
        var _collision = ((_hotglueName != undefined) && struct_exists(_collisionDictionary, _hotglueName));
        
        if (_node.__isFolder)
        {
            if (_collision)
            {
                ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            }
            
            var _open = ImGuiTreeNodeEx($"{_node.GetName()}##{ptr(_node)}", ImGuiTreeNodeFlags.OpenOnArrow | ImGuiTreeNodeFlags.OpenOnDoubleClick);
            
            if (_collision)
            {
                ImGuiPopStyleColor();
            }
            
            if (_node.__selectable && (_hotglueName != undefined) && ImGuiIsItemClicked() && (not ImGuiIsItemToggledOpen()))
            {
                if (struct_exists(__selectedDict, _hotglueName))
                {
                    struct_remove(__selectedDict, _hotglueName);
                }
                else
                {
                    __selectedDict[$ _hotglueName] = true;
                }
            }
            
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
                        __BuildTree(_children[_i], _collisionDictionary);
                        ++_i;
                    }
                }
                
                ImGuiTreePop();
            }
        }
        else
        {
            if (_collision)
            {
                ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            }
            
            ImGuiTreeNodeEx($"{_node.GetName()}##{ptr(_node)}", ImGuiTreeNodeFlags.Leaf);
            
            if (_collision)
            {
                ImGuiPopStyleColor();
            }
            
            ImGuiTreePop();
        }
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
        
        __BuildTree(_projectStructure.__rootNode, _collisionDictionary);
        __BuildTree(_projectStructure.__includedFilesNode, _collisionDictionary);
    }
}