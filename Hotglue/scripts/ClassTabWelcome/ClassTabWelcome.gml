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
        InterfaceBuildCredits();
        
        if ((HOTGLUE_GITHUB_CLIENT_ID == "") || (HOTGLUE_GITHUB_CLIENT_SECRET == ""))
        {
            ImGuiNewLine();
            ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            ImGuiTextWrapped("GitHub has relatively tight rate limiting. To get around the rate limits, you should authorize Hotglue as a GitHub app. This build does not contain a client ID and/or client secret and so cannot connect to GitHub for authorization. Please see `__HotglueConfig`.");
            ImGuiPopStyleColor();
        }
        else
        {
            if (not HotglueGetGitHubAccessTokenAvailable())
            {
                ImGuiNewLine();
                ImGuiTextWrapped("GitHub has relatively tight rate limiting. To get around the rate limits, you should authorize Hotglue as a GitHub app. Please click this button to start the authorization flow:");
                if (ImGuiButton("Authorize GitHub"))
                {
                    InterfaceGitHubAuthFlow();
                }
            }
        }
    }
}