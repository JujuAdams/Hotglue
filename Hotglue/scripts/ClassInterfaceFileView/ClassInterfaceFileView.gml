// Feather disable all

/// @param file

function ClassInterfaceFileView(_file) constructor
{
    __file = _file;
    __rename = undefined;
    
    static GetPath = function()
    {
        return __file.GetPath();
    }
    
    static GetName = function()
    {
        return __rename ?? __file.GetName();
    }
    
    static Build = function(_project = undefined)
    {
        var _quickAssetDict = (_project == undefined)? {} : _project.__quickAssetDict
        
        ImGuiSetNextItemWidth(200);
        var _newName = ImGuiInputText("", __rename ?? __file.GetName());
        if (_newName == "")
        {
            __rename = undefined;
        }
        
        ImGuiSameLine();
        
        if (variable_struct_exists(_quickAssetDict, $"resource:{_newName}"))
        {
            ImGuiTextColored(__file.GetPath(), INTERFACE_COLOR_RED_TEXT);
        }
        else
        {
            ImGuiText(__file.GetPath());
        }
        
        if (ImGuiBeginItemTooltip())
        {
            ImGuiTextUnformatted(__file.GetPath());
            ImGuiEndTooltip();
        }
    }
}