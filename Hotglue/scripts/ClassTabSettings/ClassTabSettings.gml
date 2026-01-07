// Feather disable all

function ClassTabSettings() : ClassTab() constructor
{
    static __name = "Settings";
    
    __advanced = false;
    
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
        ///////
        // URI
        ///////
        
        ImGuiText("URI (Application Link)");
        ImGuiIndent();
        
        if (HOTGLUE_RUNNING_FROM_IDE)
        {
            ImGuiTextLink("How do I register a URI?");
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Hotglue must be run from a compiled executable for URI registration to be available.");
                ImGuiEndTooltip();
            }
        }
        else
        {
            ImGuiTextWrapped("");
        }
        
        ImGuiBeginDisabled(HOTGLUE_RUNNING_FROM_IDE);
        if (ImGuiButton("Register URI"))
        {
            HotglueURIRegister();
        }
        ImGuiEndDisabled();
        
        ImGuiSameLine();
        
        if (ImGuiButton("Test URI"))
        {
            HotglueURITest();
        }
        
        ImGuiUnindent();
        
        ImGuiNewLine();
        
        ///////
        // GitHub
        ///////
        
        ImGuiText("GitHub:");
        ImGuiIndent();
        
        ImGuiTextLink("How do I authorize GitHub?");
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"Hotglue must be URI registered for GitHub authorization to be available. You may test URI registration by clicking the button above.");
            ImGuiEndTooltip();
        }
        
        if ((HOTGLUE_GITHUB_CLIENT_ID == "") || (HOTGLUE_GITHUB_CLIENT_SECRET == ""))
        {
            ImGuiTextColored("Client ID and/or client secret not set (please see `__HotglueConfig`).\nAccess token not available.", INTERFACE_COLOR_ORANGE_TEXT);
        }
        else
        {
            if (HotglueGitHubGetAccessTokenAvailable())
            {
                ImGuiText("Access token acquired.");
                
                if (ImGuiButton("Re-authorize GitHub via URI..."))
                {
                    InterfaceGitHubAuthFlow(true);
                }
            }
            else
            {
                ImGuiTextColored("GitHub access token unavailable. Please click the button below to acquire an access token from GitHub.", INTERFACE_COLOR_ORANGE_TEXT);
                
                if (ImGuiButton("Authorize GitHub via URI..."))
                {
                    InterfaceGitHubAuthFlow();
                }
            }
        }
        
        ImGuiUnindent();
        ImGuiNewLine();
        
        ///////
        // itch.io
        ///////
        
        ImGuiText("itch.io:");
        ImGuiIndent();
        
        ImGuiTextLink("How do I authorize itch.io?");
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"1. Visit the link below\n2. Create an API key\n3. Copy-paste the API key into the text field\n4. Clear the HTTP cache");
            ImGuiEndTooltip();
        }
        
        InterfaceLinkText("https://itch.io/user/settings/api-keys");
        
        var _value = ImGuiInputText("##itchAPIKey", HotglueGetItchAPIKey());
        if (InterfaceSettingSet("itch", _value))
        {
            HotglueSetItchAPIKey(_value);
            InterfaceSettingsSave();
        }
        
        ImGuiUnindent();
        ImGuiNewLine();
        
        ///////
        // Channels
        ///////
        
        ImGuiText("Channels:");
        ImGuiIndent();
        ImGuiBeginChild("channelsPane", undefined, 170, ImGuiChildFlags.Border);
        
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
        if (ImGuiButton("Add new channel..."))
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
        
        ImGuiText("Boot Behaviour:");
        ImGuiIndent();
        
        ImGuiText("Show tab on boot");
        ImGuiSameLine();
        ImGuiSetNextItemWidth(200);
        if (ImGuiBeginCombo("##bootTab", InterfaceSettingGet("openOnTab", "Welcome"), ImGuiComboFlags.None))
        {
            if (ImGuiSelectable("Welcome"))
            {
                InterfaceSettingSet("openOnTab", "Welcome");
                InterfaceSettingsSave();
            }
            
            if (ImGuiSelectable("Import"))
            {
                InterfaceSettingSet("openOnTab", "Import");
                InterfaceSettingsSave();
            }
            
            if (ImGuiSelectable("Project Inspector"))
            {
                InterfaceSettingSet("openOnTab", "Project Inspector");
                InterfaceSettingsSave();
            }
            
            if (ImGuiSelectable("Explore Channels"))
            {
                InterfaceSettingSet("openOnTab", "Explore Channels");
                InterfaceSettingsSave();
            }
            
            if (ImGuiSelectable("Settings"))
            {
                InterfaceSettingSet("openOnTab", "Settings");
                InterfaceSettingsSave();
            }
            
            ImGuiEndCombo();
        }
        
        ImGuiText("Show log on boot");
        ImGuiSameLine();
        var _oldValue = InterfaceSettingGet("showLogOnBoot", false);
        var _newValue = ImGuiCheckbox("##showLogOnBoot", _oldValue);
        if (_oldValue != _newValue)
        {
            InterfaceSettingSet("showLogOnBoot", not _oldValue)
            InterfaceSettingsSave();
        }
        
        if (ImGuiButton("Re-run \"First Time Setup\""))
        {
            oInterface.popUpStruct = new ClassModalFTUX();
        }
        
        ImGuiUnindent();
        ImGuiNewLine();
        
        ///////
        // Caches
        ///////
        
        ImGuiText("Caches:");
        ImGuiIndent();
        InterfaceLinkText(HotglueGetCachePath());
        
        if (ImGuiButton("Clear HTTP cache"))
        {
            HttpCacheClear();
            LogTraceAndStatus("Cleared HTTP cache");
        }
        
        ImGuiSameLine(undefined, 20);
        
        if (ImGuiButton("Clear unzip cache"))
        {
            HotglueClearUnzipCache();
            LogTraceAndStatus("Cleared unzip cache");
        }
        ImGuiUnindent();
        
        ImGuiNewLine();
        
        ///////
        // Paths
        ///////
        
        ImGuiText("Paths:");
        ImGuiIndent();
        
        ImGuiBeginTable("pathsTable", 5, ImGuiTableFlags.RowBg);
        ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthFixed, 160);
        ImGuiTableSetupColumn("path");
        ImGuiTableSetupColumn("browse", ImGuiTableColumnFlags.WidthFixed, 70);
        ImGuiTableSetupColumn("test", ImGuiTableColumnFlags.WidthFixed, 40);
        ImGuiTableSetupColumn("reset", ImGuiTableColumnFlags.WidthFixed, 50);
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Cache Directory");
        
        ImGuiTableNextColumn();
        var _oldString = HotglueGetCachePath();
        var _newString = ImGuiInputText("###cachePathInput", _oldString);
        if (ImGuiIsItemDeactivatedAfterEdit() && (_oldString != _newString))
        {
            HotglueSetCachePath(_newString);
            HttpCacheSetDirectory($"{_newString}httpCache/");
            InterfaceSettingsSave();
        }
        
        ImGuiTableNextColumn();
        if (ImGuiButton("Open...##cachePath"))
        {
            InterfaceOpenURL(HotglueGetCachePath());
        }
        
        ImGuiTableNextColumn();
        
        ImGuiTableNextColumn();
        if (ImGuiButton("Reset##cachePath"))
        {
            HotglueSetCachePath(HOTGLUE_DEFAULT_PATH_CACHE);
            HttpCacheSetDirectory($"{HOTGLUE_DEFAULT_PATH_CACHE}httpCache/");
        }
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Savedata Directory");
        
        ImGuiTableNextColumn();
        var _oldString = InterfaceSettingGet("savedataPath", "");
        var _newString = ImGuiInputText("###savedataPathInput", _oldString);
        if (ImGuiIsItemDeactivatedAfterEdit() && (_oldString != _newString))
        {
            InterfaceSettingSet("savedataPath", _newString);
            InterfaceSettingsSave();
        }
        
        ImGuiTableNextColumn();
        if (ImGuiButton("Open...##savedataPath"))
        {
            InterfaceOpenURL(HotglueGetCachePath());
        }
        
        ImGuiTableNextColumn();
        
        ImGuiTableNextColumn();
        if (ImGuiButton("Reset##savedataPath"))
        {
            InterfaceSettingSet("savedataPath", INTERACE_DEFAULT_PATH_SAVEDATA);
        }
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("ProjectTool.exe");
        
        ImGuiTableNextColumn();
        InterfaceLinkText(HotglueGetProjectToolPath());
        
        ImGuiTableNextColumn();
        if (ImGuiButton("Browse..."))
        {
            var _newPath = get_open_filename("*.*", "");
            if (_newPath != "")
            {
                if (HotglueSetProjectToolPath(_newPath))
                {
                    InterfaceSettingsSave();
                }
            }
        }
        
        ImGuiTableNextColumn();
        if (ImGuiButton("Test"))
        {
            oInterface.popUpStruct = new ClassModalMessage(HotglueProjectToolTest()? "Test successful." : "Test failed. Please check the log for more information.");
        }
        
        ImGuiTableNextColumn();
        if (ImGuiButton("Reset##projectToolPath"))
        {
            HotglueSetProjectToolPath(HOTGLUE_DEFAULT_PATH_PROJECTTOOL, false);
        }
        
        ImGuiEndTable();
        ImGuiUnindent();
        
        ImGuiNewLine();
        
        ///////
        // Here be dragons
        ///////
        
        ImGuiNewLine();
        
        ImGuiTextColored("Here be dragons:", INTERFACE_COLOR_RED_TEXT);
        ImGuiIndent();
        
        __advanced = ImGuiCheckbox("I know what I'm doing", __advanced);
        if (__advanced)
        {
            HotglueSetSuppressGitAssert(ImGuiCheckbox("Suppress .git directory assert", HotglueGetSuppressGitAssert()));
            
            var _oldValue = InterfaceSettingGet("showAutomation", false);
            var _newValue = ImGuiCheckbox("Show \"Automation\" mode##showAutomation", _oldValue);
            if (_oldValue != _newValue)
            {
                InterfaceSettingSet("showAutomation", not _oldValue)
                InterfaceSettingsSave();
            }
            
            if (ImGuiButton("Reset Settings"))
            {
                InterfaceSettingsReset();
                InterfaceSettingsSave();
            }
        }
        
        ImGuiUnindent();
    }
}