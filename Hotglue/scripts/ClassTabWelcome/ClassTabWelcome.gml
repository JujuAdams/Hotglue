// Feather disable all

function ClassTabWelcome() : ClassTab() constructor
{
    static __name = "Welcome";
    
    static MenuItem = function()
    {
        if (ImGuiMenuItem(__name))
        {
            other.menuFocus = self;
            other.logOpen = false;
        }
    }
    
    static Build = function()
    {
        ImGuiTextWrapped($"Welcome to Hotglue by Juju Adams! This is version {HOTGLUE_VERSION}, {HOTGLUE_DATE}.");
        ImGuiNewLine();
        ImGuiTextWrapped("This is a pre-release build and things may break. Please proceed carefully and always use source control.");
        ImGuiNewLine();
        InterfaceBuildCredits();
    }
}