// Feather disable all

function ClassTabWelcome() : ClassTab() constructor
{
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Welcome", undefined, (oInterface.forceSelectedTab == self)? ImGuiTabItemFlags.SetSelected : undefined))
        {
            ImGuiSetCursorPosY(ImGuiGetCursorPosY() + 3);
            ImGuiTextWrapped("Welcome to Hotglue by Juju Adams. This is version 0.0.0, 2025-11-09.");
            ImGuiNewLine();
            ImGuiTextWrapped("Hotglue is a GameMaker 2024.14 import tool. It will help you import and update libraries in your GameMaker project.");
            ImGuiNewLine();
            
            ImGuiText("Credits:");
            ImGuiIndent();
            ImGuiTextWrapped("ImGui by Omar Cornut");
            ImGuiTextWrapped("ImGM by knno (based on work by Nommiin)");
            ImGuiTextWrapped("execute_shell_simple() by YellowAfterlife");
            ImGuiTextWrapped("Ngram fuzzy search by TinkererRed");
            ImGuiTextWrapped("GitHub authorization flow based on `GitHub.gml` by Alub");
            ImGuiUnindent();
            
            if (HotglueGetExecuteShellAvailable())
            {
                
            }
            else
            {
                ImGuiNewLine();
                ImGuiTextWrapped("Hotglue has support for `execute_shell_simple` by YellowAfterlife. This is, however, a paid asset. Please visit the link below, toss YellowAfterlife some money, and download the extension.");
                ImGuiTextLinkOpenURL("execute_shell_simple on itch.io", "https://yellowafterlife.itch.io/gamemaker-execute-shell-simple");
            }
            
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
            
            ImGuiEndTabItem();
        }
    }
}