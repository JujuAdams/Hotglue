// Feather disable all

/// @param job
/// @param [packageEditForce=false]

function ClassModalConfirmJob(_job, _packageEditForce = false) constructor
{
    __job = _job;
    
    __loadPending = false;
    __loadSuccessful = true;
    
    __packageEditForce = _packageEditForce;
    
    
    
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
            ImGuiText((array_length(__job.GetAddArray()) > 0)? "Import as package" : "Package edit");
            ImGuiTableNextColumn();
            ImGuiBeginDisabled(__packageEditForce);
            __job.SetPackageEdit(ImGuiCheckbox("##packageEdit", __job.GetPackageEdit()));
            ImGuiEndDisabled();
            
            ImGuiBeginDisabled(not __job.GetPackageEdit());
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Package name");
            ImGuiTableNextColumn();
            
            if (__packageEditForce)
            {
                ImGuiText(__job.GetPackageName());
            }
            else
            {
                ImGuiSetNextItemWidth(200);
                __job.SetPackageName(ImGuiInputTextWithHint("##packageName", "(no package name)", __job.GetPackageName()));
                
                if (__job.GetPackageEdit() && (__job.GetPackageName() == ""))
                {
                    ImGuiSameLine();
                    ImGuiTextColored("Please enter a package name", INTERFACE_COLOR_RED_TEXT, 1);
                }
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Package version");
            ImGuiTableNextColumn();
            
            if (__packageEditForce)
            {
                ImGuiText(__job.GetPackageVersion());
            }
            else
            {
                ImGuiSetNextItemWidth(200);
                __job.SetPackageVersion(ImGuiInputTextWithHint("##packageversion", "0.0.0", __job.GetPackageVersion()));
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Package origin");
            ImGuiTableNextColumn();
            var _url = __job.GetPackageURL();
            ImGuiText((_url == "")? "(no origin URL)" : _url);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Content date");
            ImGuiTableNextColumn();
            var _contentDate = __job.GetContentDate();
            ImGuiText((_contentDate == 0)? "(no content date)" : date_datetime_string(_contentDate));
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Repo URL");
            ImGuiTableNextColumn();
            var _repositoryURL = __job.GetRepositoryURL();
            ImGuiText((_repositoryURL == "")? "(no repository URL)" : _repositoryURL);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Repo type");
            ImGuiTableNextColumn();
            var _repositoryType = __job.GetRepositoryType();
            ImGuiText((_repositoryType == undefined)? "(no repository type)" : _repositoryType);
            
            ImGuiEndDisabled();
            ImGuiEndDisabled();
            
            ImGuiEndTable();
            
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
                
                var _conflictArray  = __job.GetConflictArray();
                var _overwriteArray = __job.GetOverwriteArray();
                
                if ((array_length(_conflictArray) > 0) || (array_length(_overwriteArray) > 0))
                {
                    ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
                    ImGuiTextWrapped("Be sure to back up any configuration macros you may have adjusted.");
                    ImGuiPopStyleColor();
                }
            }
            
            ImGuiNewLine();
            ImGuiBeginDisabled(__loadPending || (not __loadSuccessful) || (__job == undefined) || (__job.GetPackageEdit() && (__job.GetPackageName() == "")));
            if (ImGuiButton("Confirm"))
            {
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