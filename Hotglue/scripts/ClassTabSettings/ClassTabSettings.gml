// Feather disable all

function ClassTabSettings() : ClassTab() constructor
{
    __advanced = false;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Settings"))
        {
            __advanced = ImGuiCheckbox("I know what I'm doing", __advanced);
            if (__advanced)
            {
                ImGuiIndent();
                ImGuiTextColored("Here be dragons.", INTERFACE_COLOR_RED_TEXT);
                HotglueSetSuppressGitAssert(ImGuiCheckbox("Suppress .git directory assert", HotglueGetSuppressGitAssert()));
                HotglueSetDestructiveCopy(ImGuiCheckbox("Resource copy is destructive", HotglueGetDestructiveCopy()));
                ImGuiUnindent();
            }
            
            ImGuiEndTabItem();
        }
    }
}