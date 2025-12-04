// Feather disable all

function __InterfaceProjectViewBuildTreeAsDestination()
{
    BuildTreeAsDestination = method(undefined, function(_comparisonData = undefined)
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
    });
    
    __BuildTreeAsDestinationInner = method(undefined, function(_node, _collisionDictionary)
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
    });
}