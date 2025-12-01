/// @param url
/// @param standbyName

function ClassLink(_url, _standbyName) constructor
{
    __url = _url;
    __standbyName = _standbyName;
    
    __officialName = undefined;
    __customName = undefined;
    
    static GetURL = function()
    {
        return __url;
    }
    
    static GetName = function()
    {
        return __customName ?? (__officialName ?? __standbyName);
    }
    
    static GetEdittable = function()
    {
        return false;
    }
    
    static GetVersionString = function()
    {
        return "0.0.0-alpha";
    }
    
    static GetDependencies = function()
    {
        return [{
            name: "Scribble",
            version: "10.0.0",
            url: "https://www.github.com/jujuadams/scribble",
            remote: true,
        }, {
            name: "Input",
            version: "10.2.2",
            url: "https://www.github.com/offalynne/input",
            remote: false,
        }];
    }
    
    static GetMetadataExists = function()
    {
        //TODO
        return false;
    }
    
    static CreateMetadata = function()
    {
        if (not GetEdittable()) return;
        //TODO
    }
    
    static BuildForView = function()
    {
        var _cellPadding = 8;
        
        ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
        ImGuiBeginTable("overviewTable", 2, ImGuiTableFlags.RowBg);
        
        ImGuiTableSetupColumn("field", ImGuiTableColumnFlags.WidthFixed, 130);
        ImGuiTableSetupColumn("value");
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("* Favourite *");
        ImGuiTableNextColumn();
        
        var _favoriteArray = InterfaceSettingGet("favoriteLinks");
        var _oldFavorite = (array_get_index(_favoriteArray, GetURL()) >= 0);
        var _newFavorite = ImGuiCheckbox("##favorite", _oldFavorite);
        if (_newFavorite != _oldFavorite)
        {
            if (_newFavorite)
            {
                array_push(InterfaceSettingGet("favoriteLinks"), GetURL());
                InterfaceStatus($"Favourited \"{GetURL()}\"");
            }
            else
            {
                var _index = array_get_index(_favoriteArray, GetURL());
                if (_index >= 0) array_delete(_favoriteArray, _index, 1);
                InterfaceStatus($"Unfavourited \"{GetURL()}\"");
            }
            
            oInterface.favoritesTab.dirty = true;
            InterfaceSettingsSave();
        }
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Name");
        ImGuiTableNextColumn();
        ImGuiTextWrapped(GetName());
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        
        var _clicked = ImGuiTextLink("Semantic Version");
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"Open \"https://semver.org/\"");
            ImGuiEndTooltip();
        }
        
        if (_clicked)
        {
            
        }
        
        ImGuiTableNextColumn();
        ImGuiText(GetVersionString());
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("URL");
        ImGuiTableNextColumn();
        
        var _clicked = ImGuiTextLink(GetURL());
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"Open \"{GetURL()}\"");
            ImGuiEndTooltip();
        }
        
        if (_clicked)
        {
            
        }
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Dependencies");
        ImGuiTableNextColumn();
        
        var _dependenciesArray = GetDependencies();
        
        ImGuiPopStyleVar();
        ImGuiBeginTable("overviewTable", 2);
        
        ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthFixed, 120);
        ImGuiTableSetupColumn("version");
        
        var _i = 0;
        repeat(array_length(_dependenciesArray))
        {
            var _dependency = _dependenciesArray[_i];
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            
            var _clicked = ImGuiTextLink(_dependency.name);
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Open \"{_dependency.url}\"");
                ImGuiEndTooltip();
            }
            
            if (_clicked)
            {
                
            }
            
            ImGuiTableNextColumn();
            ImGuiTextWrapped(_dependency.version);
            
            ++_i;
        }
        
        ImGuiEndTable();
        ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        
        var _clicked = ImGuiTextLink("Scripting");
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"View scripting");
            ImGuiEndTooltip();
        }
        
        if (_clicked)
        {
            
        }
        
        ImGuiTableNextColumn();
        
        ImGuiBeginDisabled(true);
        ImGuiCheckbox("Before import", true);
        ImGuiSameLine();
        ImGuiSetCursorPosX(ImGuiGetCursorPosX() + 5)
        ImGuiCheckbox("After import", true);
        ImGuiEndDisabled();
        
        ImGuiEndTable();
        ImGuiPopStyleVar();
    }
    
    static BuildForEdit = function()
    {
        var _cellPadding = 8;
        
        ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
        ImGuiBeginTable("overviewTable", 3, ImGuiTableFlags.RowBg);
        
        ImGuiTableSetupColumn("field", ImGuiTableColumnFlags.WidthFixed, 180);
        ImGuiTableSetupColumn("value");
        ImGuiTableSetupColumn("button", ImGuiTableColumnFlags.WidthFixed, 50);
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("* Favourite *");
        ImGuiTableNextColumn();
        ImGuiCheckbox("##favorite", false);
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Name");
        ImGuiTableNextColumn();
        ImGuiTextWrapped(GetName());
        ImGuiTableNextColumn();
        ImGuiSmallButton("Reset##name");
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        
        var _clicked = ImGuiTextLink("Semantic Version");
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"Open \"https://semver.org/\"");
            ImGuiEndTooltip();
        }
        
        if (_clicked)
        {
            
        }
        
        ImGuiTableNextColumn();
        ImGuiText(GetVersionString());
        ImGuiSetNextItemWidth(40);
        ImGuiInputTextWithHint("##semverMajor", "MAJOR", "");
        ImGuiSameLine();
        ImGuiText(".");
        ImGuiSameLine();
        ImGuiSetNextItemWidth(40);
        ImGuiInputTextWithHint("##semverMinor", "Minor", "");
        ImGuiSameLine();
        ImGuiText(".");
        ImGuiSameLine();
        ImGuiSetNextItemWidth(40);
        ImGuiInputTextWithHint("##semverPatch", "patch", "");
        ImGuiSameLine();
        ImGuiSetNextItemWidth(200);
        ImGuiInputTextWithHint("##semverExt", "-extension", "");
        ImGuiTableNextColumn();
        ImGuiSmallButton("Reset##version");
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText(".yymps overrides version");
        
        ImGuiTableNextColumn();
        ImGuiCheckbox("##yympsOverridesVersion", true);
        ImGuiSameLine();
        ImGuiTextLink("What is this?");
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"Enable to allow .yymps exports to override the version set in \"hotglue.json\".\nThis makes .yymps export more convenient.");
            ImGuiEndTooltip();
        }
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("URL");
        ImGuiTableNextColumn();
        
        var _clicked = ImGuiTextLink(GetURL());
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"Open \"{GetURL()}\"");
            ImGuiEndTooltip();
        }
        
        if (_clicked)
        {
            
        }
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        ImGuiText("Dependencies");
        ImGuiTableNextColumn();
        
        var _dependenciesArray = GetDependencies();
        
        ImGuiPopStyleVar();
        ImGuiBeginTable("overviewTable", 2);
        
        ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthFixed, 120);
        ImGuiTableSetupColumn("version");
        
        var _i = 0;
        repeat(array_length(_dependenciesArray))
        {
            var _dependency = _dependenciesArray[_i];
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            
            var _clicked = ImGuiTextLink(_dependency.name);
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"Open \"{_dependency.url}\"");
                ImGuiEndTooltip();
            }
            
            if (_clicked)
            {
                
            }
            
            ImGuiTableNextColumn();
            ImGuiTextWrapped(_dependency.version);
            
            ++_i;
        }
        
        ImGuiEndTable();
        ImGuiPushStyleVarY(ImGuiStyleVar.CellPadding, _cellPadding);
        
        ImGuiTableNextRow();
        ImGuiTableNextColumn();
        
        var _clicked = ImGuiTextLink("Scripting");
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"Edit scripting");
            ImGuiEndTooltip();
        }
        
        if (_clicked)
        {
            
        }
        
        ImGuiTableNextColumn();
        
        ImGuiBeginDisabled(true);
        ImGuiCheckbox("Before import", true);
        ImGuiSameLine();
        ImGuiSetCursorPosX(ImGuiGetCursorPosX() + 5)
        ImGuiCheckbox("After import", true);
        ImGuiEndDisabled();
        
        ImGuiEndTable();
        ImGuiPopStyleVar();
    }
}