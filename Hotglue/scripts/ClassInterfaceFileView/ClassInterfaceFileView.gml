// Feather disable all

/// @param file

function ClassInterfaceFileView(_file) constructor
{
    __file = _file;
    __rename = undefined;
    __importType = "Included File";
    
    ResetImportType();
    
    
    
    static GetPath = function()
    {
        return __file.GetPath();
    }
    
    static GetName = function()
    {
        return __rename ?? GetOriginalName();
    }
    
    static GetOriginalName = function()
    {
        return (__importType == "Included File")? filename_name(__file.GetPath()) : __file.GetName();
    }
    
    static SetName = function(_newName)
    {
        if ((_newName == "") || (_newName == GetOriginalName()))
        {
            __rename = undefined;
        }
        else
        {
            __rename = (__importType == "Included File")? _newName : HotglueSanitizeResourceName(_newName);
        }
    }
    
    static GetImportType = function()
    {
        return __importType;
    }
    
    static SetImportType = function(_importType)
    {
        if (_importType != __importType)
        {
            if (__rename != undefined)
            {
                if (_importType == "Included File")
                {
                    __rename = filename_change_ext(__rename, filename_ext(GetPath()));
                }
                else
                {
                    __rename = HotglueSanitizeResourceName(__rename);
                }
            }
            
            __importType = _importType;
        }
    }
    
    static ResetImportType = function()
    {
        if (__file.GetRecommendedType() == "resource")
        {
            var _recommendedResourceType = __file.GetRecommendedResourceType();
            if (_recommendedResourceType == "script")
            {
                SetImportType("Script");
            }
            else if (_recommendedResourceType == "sound")
            {
                SetImportType("Sound");
            }
            else if (_recommendedResourceType == "sprite")
            {
                SetImportType("Sprite");
            }
            else
            {
                SetImportType("Note");
            }
        }
        else
        {
            SetImportType("Included File");
        }
    }
    
    static Build = function(_project = undefined)
    {
        var _quickAssetDict = (_project == undefined)? {} : _project.__quickAssetDict
        
        ImGuiSetNextItemWidth(200);
        SetName(ImGuiInputText($"##rename{ptr(__file)}", GetName()));
        
        ImGuiSameLine();
        
        ImGuiSetNextItemWidth(120);
        if (ImGuiBeginCombo($"##combo{ptr(__file)}", __importType, ImGuiComboFlags.None))
        {
            var _newResourceType = __importType;
            
            if (ImGuiSelectable($"Script##{ptr(__file)}", (__importType == "Script")))
            {
                _newResourceType = "Script";
            }
            
            if (ImGuiSelectable($"Sound##{ptr(__file)}", (__importType == "Sound")))
            {
                _newResourceType = "Sound";
            }
            
            if (ImGuiSelectable($"Sprite##{ptr(__file)}", (__importType == "Sprite")))
            {
                _newResourceType = "Sprite";
            }
            
            if (ImGuiSelectable($"Included File##{ptr(__file)}", (__importType == "Included File")))
            {
                _newResourceType = "Included File";
            }
            
            if (ImGuiSelectable($"Note##{ptr(__file)}", (__importType == "Note")))
            {
                _newResourceType = "Note";
            }
            
            SetImportType(_newResourceType);
            
            ImGuiEndCombo();
        }
        
        ImGuiSameLine();
        
        var _assetRef = (__importType == "Included File")? $"included:{GetName()}" : $"resource:{GetName()}";
        if (variable_struct_exists(_quickAssetDict, _assetRef))
        {
            ImGuiTextColored(filename_name(__file.GetPath()), INTERFACE_COLOR_RED_TEXT);
        }
        else
        {
            ImGuiText(filename_name(__file.GetPath()));
        }
        
        if (ImGuiBeginItemTooltip())
        {
            ImGuiTextUnformatted(__file.GetPath());
            ImGuiEndTooltip();
        }
    }
}