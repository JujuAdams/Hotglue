// Feather disable all

/// @param project
/// @param libraryName

function ClassModalConfirmLibraryDelete(_project, _libraryName) constructor
{
    __project     = _project;
    __libraryName = _libraryName;
    
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(0.5*oInterface.context.GetRegion().width, 0.666*oInterface.context.GetRegion().height);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiText($"Are you sure you want to delete \"{__libraryName}\" from project \"{__project.GetName()}\"?");
            ImGuiNewLine();
            
            if (ImGuiButton("Delete"))
            {
                __project.DeleteLibrary(__libraryName);
                oInterface.popUpStruct = new ClassModalMessage($"Deleted \"{__libraryName}\" from project \"{__project.GetName()}\".");
            }
            
            ImGuiSameLine(undefined, 20);
            if (ImGuiButton("Cancel"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiEndPopup();
            
            return true;
        }
        else
        {
            return false;
        }
    }
}