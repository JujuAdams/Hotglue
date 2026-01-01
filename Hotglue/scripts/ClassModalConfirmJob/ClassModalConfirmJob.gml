// Feather disable all

/// @param job
/// @param [forceImportAsPackage=false]
/// @param [packageName=""]
/// @param [packageVersion="0.0.0"]

function ClassModalConfirmJob(_job, _forceImportAsPackage = false, _packageName = "", _packageVersion = "0.0.0") constructor
{
    __job = _job;
    
    __loadPending = false;
    __loadSuccessful = true;
    
    __packageImportForce = _forceImportAsPackage;
    __packageImport      = _forceImportAsPackage;
    __packageName        = "";
    __packageVersion     = "0.0.0";
    
    
    
    static __SetState = function(_forceImportAsPackage, _packageName, _packageVersion)
    {
        __packageImportForce = _forceImportAsPackage;
        __packageImport      = _forceImportAsPackage;
        __packageName        = _packageName;
        __packageVersion     = _packageVersion;
    }
    
    static Build = function()
    {
        var _name = $"Confirm Import##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(0.5*oInterface.context.GetRegion().width, 0.666*oInterface.context.GetRegion().height);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            ImGuiBeginTable("overviewTable", 2, ImGuiTableFlags.RowBg | ImGuiTableFlags.Borders);
            
            ImGuiTableSetupColumn("field", ImGuiTableColumnFlags.WidthFixed, 120);
            ImGuiTableSetupColumn("value");
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Import subfolder");
            ImGuiTableNextColumn();
            ImGuiSetNextItemWidth(200);
            __job.SetSubfolder(ImGuiInputTextWithHint("##importSubfolder", "(project root)", __job.GetSubfolder()));
            
            ImGuiBeginDisabled(not __loadSuccessful);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Import as package");
            ImGuiTableNextColumn();
            ImGuiBeginDisabled(__packageImportForce);
            __packageImport = ImGuiCheckbox("##importAsPackage", __packageImport);
            ImGuiEndDisabled();
            
            ImGuiBeginDisabled(not __packageImport);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Package name");
            ImGuiTableNextColumn();
            
            if (__packageImportForce)
            {
                ImGuiText(__packageName);
            }
            else
            {
                ImGuiSetNextItemWidth(200);
                __packageName = ImGuiInputTextWithHint("##packageName", "(no package name)", __packageName);
                
                if (__packageImport && (__packageName == ""))
                {
                    ImGuiSameLine();
                    ImGuiTextColored("Please enter a package name", INTERFACE_COLOR_RED_TEXT, 1);
                }
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Package version");
            ImGuiTableNextColumn();
            
            if (__packageImportForce)
            {
                ImGuiText(__packageVersion);
            }
            else
            {
                ImGuiSetNextItemWidth(200);
                __packageVersion = ImGuiInputTextWithHint("##packageversion", "0.0.0", __packageVersion);
            }
            
            ImGuiEndTable();
            ImGuiEndDisabled();
            ImGuiEndDisabled();
            
            ImGuiNewLine();
            
            if ((not __loadPending) && (not __loadSuccessful))
            {
                ImGuiTextColored("Failed to load release project.", INTERFACE_COLOR_RED_TEXT);
                ImGuiText("Please check the log for more information.");
            }
            else if (__loadPending)
            {
                ImGuiText("Loading release project, please wait...");
            }
            else
            {
                ImGuiText("Please confirm that you would like to make the following changes.");
            }
            
            ImGuiNewLine();
            ImGuiBeginDisabled(__loadPending || (not __loadSuccessful) || (__job == undefined) || (__packageImport && (__packageName == "")));
            if (ImGuiButton("Confirm"))
            {
                if (__packageVersion == "")
                {
                    __packageVersion = "0.0.0";
                }
                
                var _success = false;
                try
                {
                    __job.Execute();
                    _success = true;
                }
                catch(_error)
                {
                    LogWarning(json_stringify(_error, true));
                }
                
                if (_success)
                {
                    var _message = "Job completed successfully.";
                }
                else
                {
                    var _message = "Job encountered an error. Please check the log for more information.";
                }
                
                oInterface.popUpStruct = new ClassModalMessage(_message);
            }
            ImGuiEndDisabled();
            
            ImGuiSameLine(undefined, 50);
            if (ImGuiButton("Abort"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            if ((not __loadPending) && __loadSuccessful)
            {
                ImGuiNewLine();
                
                var _func = function(_title, _array)
                {
                    if (ImGuiCollapsingHeader($"{_title} ({array_length(_array)})"))
                    {
                        if (array_length(_array) <= 0)
                        {
                            ImGuiText($"(No {string_lower(_title)})");
                        }
                        else
                        {
                            ImGuiText($"{array_length(_array)} {string_lower(_title)}:");
                            
                            var _i = 0;
                            repeat(array_length(_array))
                            {
                                ImGuiText(_array[_i]);
                                ++_i;
                            }
                        }
                    }
                }
                
                _func("Conflicts",  __job.GetConflictArray());
                _func("Additions",  __job.GetAddArray());
                _func("Overwrites", __job.GetOverwriteArray());
                _func("Deletions",  __job.GetDeleteArray());
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