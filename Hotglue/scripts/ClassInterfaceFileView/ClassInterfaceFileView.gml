// Feather disable all

/// @param file

function ClassInterfaceFileView(_file) constructor
{
    __file = _file;
    
    
    
    static Build = function(_project = undefined)
    {
        var _quickAssetDict = (_project == undefined)? {} : _project.__quickAssetDict
        
        ImGuiSetNextItemWidth(200);
        __file.SetName(ImGuiInputText($"##rename{ptr(__file)}", __file.GetName()));
        
        ImGuiSameLine();
        
        ImGuiSetNextItemWidth(120);
        var _type = __file.GetType();
        if (ImGuiBeginCombo($"##combo{ptr(__file)}", _type, ImGuiComboFlags.None))
        {
            if (ImGuiSelectable($"script##{ptr(__file)}", (_type == "script")))
            {
                __file.SetType("script");
            }
            
            if (ImGuiSelectable($"sound##{ptr(__file)}", (_type == "sound")))
            {
                __file.SetType("sound");
            }
            
            if (ImGuiSelectable($"sprite##{ptr(__file)}", (_type == "sprite")))
            {
                __file.SetType("sprite");
            }
            
            if (ImGuiSelectable($"included file##{ptr(__file)}", (_type == "included file")))
            {
                __file.SetType("included file");
            }
            
            if (ImGuiSelectable($"note##{ptr(__file)}", (_type == "note")))
            {
                __file.SetType("note");
            }
            
            ImGuiEndCombo();
        }
        
        ImGuiSameLine();
        
        if (variable_struct_exists(_quickAssetDict, __file.GetPID()))
        {
            ImGuiTextColored(filename_name(__file.GetPath()), INTERFACE_COLOR_RED_TEXT);
        }
        else
        {
            ImGuiText(filename_name(__file.GetPath()));
        }
        
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText(__file.GetPath());
            ImGuiEndTooltip();
        }
    }
}