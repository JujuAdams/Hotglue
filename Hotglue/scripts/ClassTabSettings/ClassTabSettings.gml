// Feather disable all

function ClassTabSettings() : ClassTab() constructor
{
    __advanced = false;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Settings"))
        {
            if ((HOTGLUE_GITHUB_CLIENT_ID == "") || (HOTGLUE_GITHUB_CLIENT_SECRET == ""))
            {
                ImGuiTextColored("GitHub client ID and/or client secret not set (please see `__HotglueConfig`).\nGitHub access token not available.", INTERFACE_COLOR_ORANGE_TEXT);
            }
            else
            {
                if (HotglueGetGitHubAccessTokenAvailable())
                {
                    ImGuiText("GitHub access token available.");
                }
                else
                {
                    ImGuiTextColored("GitHub access token not available.", INTERFACE_COLOR_ORANGE_TEXT);
                    if (ImGuiButton("Authorize GitHub"))
                    {
                    }
                }
            }
            
            ImGuiNewLine();
            
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