// Feather disable all

function ClassTabSettings() : ClassTab() constructor
{
    __advanced = false;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Settings"))
        {
            ImGuiNewLine();
            
            ImGuiText("Channels:");
            ImGuiIndent();
            ImGuiBeginChild("channelsPane", undefined, 200, ImGuiChildFlags.Border);
            
            ImGuiBeginTable("channelsTable", 3, ImGuiTableFlags.RowBg);
            
            ImGuiTableSetupColumn("button", ImGuiTableColumnFlags.WidthFixed, 20);
            ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthStretch, 1);
            ImGuiTableSetupColumn("url", ImGuiTableColumnFlags.WidthStretch, 3);
            
            var _deleteIndex = undefined;
            var _i = 0;
            repeat(HotglueGetChannelCount())
            {
                var _channel = HotglueGetChannelByIndex(_i);
                
                ImGuiTableNextRow();
                ImGuiTableNextColumn();
                
                if (_channel.__protected)
                {
                    ImGuiTableNextColumn();
                    ImGuiText(_channel.GetName());
                    ImGuiTableNextColumn();
                    ImGuiText(_channel.GetURL());
                }
                else
                {
                    if (ImGuiSmallButton($"X##{string(ptr(_channel))}"))
                    {
                        _deleteIndex = _i;
                    }
                    
                    ImGuiTableNextColumn();
                    ImGuiText(_channel.GetName());
                    ImGuiTableNextColumn();
                    ImGuiText(_channel.GetURL());
                }
                
                ++_i;
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiTableNextColumn();
            if (ImGuiButton("+ Add new channel..."))
            {
                oInterface.popUpStruct = new ClassModalNewChannel();
            }
            
            if (_deleteIndex != undefined)
            {
                HotglueDeleteChannel(_deleteIndex);
                InterfaceSettingsSave();
            }
            
            ImGuiEndTable();
            ImGuiEndChild();
            ImGuiUnindent();
            
            ImGuiNewLine();
            
            ImGuiText("Caches:");
            ImGuiIndent();
            if (ImGuiButton("Clear release cache"))
            {
                HotglueClearReleaseCache();
                LogTraceAndStatus("Cleared release cache");
            }
            
            if (ImGuiButton("Clear unzip cache"))
            {
                HotglueClearUnzipCache();
                LogTraceAndStatus("Cleared unzip cache");
            }
            ImGuiUnindent();
            
            ImGuiNewLine();
            
            ImGuiText("GitHub:");
            ImGuiIndent();
            if ((HOTGLUE_GITHUB_CLIENT_ID == "") || (HOTGLUE_GITHUB_CLIENT_SECRET == ""))
            {
                ImGuiTextColored("Client ID and/or client secret not set (please see `__HotglueConfig`).\nAccess token not available.", INTERFACE_COLOR_ORANGE_TEXT);
            }
            else
            {
                if (HotglueGetGitHubAccessTokenAvailable())
                {
                    ImGuiText("Access token available.");
                }
                else
                {
                    ImGuiTextColored("Access token not available.", INTERFACE_COLOR_ORANGE_TEXT);
                    if (ImGuiButton("Authorize GitHub"))
                    {
                    }
                }
            }
            ImGuiUnindent();
            
            ImGuiNewLine();
            
            ImGuiTextColored("Here be dragons:", INTERFACE_COLOR_RED_TEXT);
            ImGuiIndent();
            
            __advanced = ImGuiCheckbox("I know what I'm doing", __advanced);
            if (__advanced)
            {
                HotglueSetSuppressGitAssert(ImGuiCheckbox("Suppress .git directory assert", HotglueGetSuppressGitAssert()));
                HotglueSetDestructiveCopy(ImGuiCheckbox("Resource copy is destructive", HotglueGetDestructiveCopy()));
            }
            
            ImGuiUnindent();
            ImGuiEndTabItem();
        }
    }
}