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
            var _otherQuickAssetDict = _comparisonData.__quickAssetDict;
            
        }
        else
        {
            var _otherQuickAssetDict = {};
            
            if (is_array(_comparisonData))
            {
                var _i = 0;
                repeat(array_length(_comparisonData))
                {
                    _otherQuickAssetDict[$ $"resource:{_comparisonData[_i].__file.GetName()}"] = true;
                    ++_i;
                }
            }
        }
        
        var _quickAssetArray = __project.__quickAssetArray;
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            var _asset = _quickAssetArray[_i];
            if (_asset.type != "folder")
            {
                var _assetName = _asset.name;
                
                if (variable_struct_exists(_otherQuickAssetDict, _assetName))
                {
                    ImGuiTextColored(_assetName, INTERFACE_COLOR_RED_TEXT);
                }
                else
                {
                    ImGuiText(_assetName);
                }
                
                if (ImGuiBeginItemTooltip())
                {
                    ImGuiTextUnformatted(_asset.GetPath());
                    ImGuiEndTooltip();
                }
            }
            
            ++_i;
        }
    }
}