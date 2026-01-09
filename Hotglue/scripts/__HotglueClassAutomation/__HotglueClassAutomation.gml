// Feather disable all

/// @param json

function __HotglueClassAutomation(_json) constructor
{
    __rootIndex = 0;
    __finished  = false;
    __error     = false;
    __operation = undefined;
    
    if (is_struct(_json))
    {
        _json = [_json];
    }
    else if (not is_array(_json))
    {
        __HotglueWarning($"Invalid automation root input (typeof={typeof(_json)}), aborting");
        __finished = true;
        __error = true;
    }
    
    __json = _json;
    __sourceProject = undefined;
    
    __project = undefined;
    __timeSource = time_source_create(time_source_global, 1, time_source_units_frames, function()
    {
        if (__finished)
        {
            __HotglueTrace("Automation complete");
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
            return;
        }
        
        if (__rootIndex >= array_length(__json))
        {
            __finished = true;
            return;
        }
        
        if (__operation != undefined)
        {
            __operation();
        }
        else
        {
            var _input = __json[__rootIndex];
            if (not is_struct(_input))
            {
                __HotglueWarning($"Invalid automation step (index={__rootIndex}, typeof={typeof(_json)}), aborting");
                __finished = true;
                __error = true;
                return;
            }
            
            if (struct_exists(_input, "destination"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n{json_stringify(_input, true)}");
                if (not __CheckClean(_input, ["destination"])) return;
                
                var _value = _input.destination
                if (not is_string(_value))
                {
                    __Error($".destination must be a string (typeof={typeof(_value)})");
                    return;
                }
                
                var _project = HotglueProjectLocalEnsure(_value);
                if (_project == undefined)
                {
                    __Error($"Failed to load \"{_value}\"");
                    return;
                }
                
                __project = _project;
                ++__rootIndex;
            }
            else if (struct_exists(_input, "suppressGitAssert"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n{json_stringify(_input, true)}");
                if (not __CheckClean(_input, ["suppressGitAssert"])) return;
                
                var _value = _input.suppressGitAssert
                if (not is_bool(_value))
                {
                    __Error($".suppressGitAssert must be true or false (typeof={typeof(_value)})");
                    return;
                }
                
                HotglueSetSuppressGitAssert(_value);
                ++__rootIndex;
            }
            else if (struct_exists(_input, "clearCache"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n{json_stringify(_input, true)}");
                if (not __CheckClean(_input, ["clearCache"])) return;
                
                if (_input.clearCache == true)
                {
                    HotglueClearUnzipCache();
                    HttpCacheClear();
                }
                
                ++__rootIndex;
            }
            else if (struct_exists(_input, "deleteLibrary"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n{json_stringify(_input, true)}");
                if (not __CheckClean(_input, ["deleteLibrary"])) return;
                
                var _value = _input.deleteLibrary
                if (not is_string(_value))
                {
                    __Error($".deleteLibrary must be a string (typeof={typeof(_value)})");
                    return;
                }
                
                var _job = __project.JobDeleteLibrary(_value);
                _job.BuildReport();
                _job.Execute();
                
                ++__rootIndex;
            }
            else if (struct_exists(_input, "itchApiKey"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n(itch.io API key hidden for security)");
                if (not __CheckClean(_input, ["itchApiKey"])) return;
                
                var _value = _input.itchApiKey
                if (not is_bool(_value))
                {
                    __Error($".itchApiKey must be a string (typeof={typeof(_value)})");
                    return;
                }
                
                HotglueSetItchAPIKey(_value);
                ++__rootIndex;
            }
            else if (struct_exists(_input, "import"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n{json_stringify(_input, true)}");
                if (not __CheckClean(_input, ["import", "assets", "subfolder", "packageName", "packageVersion"])) return;
                
                //Load a project
                var _import = _input.import;
                if (not is_string(_import))
                {
                    __Error($".import must be a string (typeof={typeof(_import)})");
                    return;
                }
                
                if (HotglueGuessURLIsRemote(_import))
                {
                    HttpCacheGetFile(_import, filename_ext(_import), function(_success, _destinationPath, _callbackData)
                    {
                        with(_callbackData)
                        {
                            if (_success)
                            {
                                __sourceProject = HotglueProjectRemoteEnsure(_destinationPath, _destinationPath);
                                __LoadProject();
                            }
                            else
                            {
                                __Error($"Failed to download remote file");
                            }
                        }
                    },
                    self);
                    
                    __operation = function() {}
                    return;
                }
                else
                {
                    __sourceProject = HotglueProjectLocalEnsure(_import);
                    __LoadProject();
                }
            }
            else
            {
                __Error($"Invalid automation step (index={__rootIndex}), aborting");
                __HotglueWarning(json_stringify(_input, true));
                return;
            }
        }
    },
    [], -1);
    
    time_source_start(__timeSource);
    
    if (not __error)
    {
        __HotglueTrace("Running automation");
    }
    
    
    
    static GetFinished = function()
    {
        return __finished;
    }
    
    static GetError = function()
    {
        return __error;
    }
    
    static __LoadProject = function()
    {
        var _input = __json[__rootIndex];
        
        if (__sourceProject == undefined)
        {
            __Error("Failed to load project");
            return;
        }
        
        //Figure out what assets we want
        var _assets = _input[$ "assets"];
        if (_assets != undefined)
        {
            if (__sourceProject.GetIsPackage())
            {
                __HotglueWarning("Cannot import parts of a .yymps package, ignoring .assets");
            }
            else
            {
                if (is_string(_assets))
                {
                    _assets = [_assets];
                }
                else if (not is_array(_assets))
                {
                    __Error($".assets must be an array (typeof={typeof(_assets)})");
                    return;
                }
            }
        }
        
        //Find the subfolder
        var _subfolder = _input[$ "subfolder"];
        if ((_subfolder != undefined) && (not is_string(_subfolder)))
        {
            __Error($".subfolder must be a string (typeof={typeof(_subfolder)})");
            return;
        }
        
        //Create a job
        if (__sourceProject.GetIsPackage())
        {
            var _job = __project.JobImportAsLibrary(__sourceProject, _subfolder);
        }
        else if (_assets == undefined)
        {
            var _job = __project.JobImportAllFrom(__sourceProject, _subfolder);
        }
        else
        {
            var _job = __project.JobImportFrom(__sourceProject, _assets, _subfolder);
        }
        
        //Set up package name and version
        var _packageName = _input[$ "packageName"];
        if ((_packageName != undefined) && (not is_string(_packageName)))
        {
            __Error($".packageName must be a string (typeof={typeof(_packageName)})");
            return;
        }
        
        var _packageVersion = _input[$ "packageVersion"];
        if ((_packageVersion != undefined) && (not is_string(_packageVersion)))
        {
            __Error($".packageVersion must be a string (typeof={typeof(_packageVersion)})");
            return;
        }
        
        if ((_packageName == undefined) && (_packageVersion != undefined))
        {
            __Error($".packageVersion cannot be set without .packageName");
            return;
        }
        
        if (is_string(_packageName))
        {
            _job.SetPackageEdit(true);
            _job.SetPackageName(_packageName ?? "");
            _job.SetPackageVersion(_packageVersion ?? "");
            _job.SetPackageURL(__sourceProject.GetURL() ?? "");
        }
        
        //Execute the job
        _job.BuildReport();
        _job.Execute();
        
        __operation = undefined;
        ++__rootIndex;
    }
    
    static __Error = function(_message)
    {
        __HotglueWarning(_message);
        __finished = true;
        __error = true;
    }
    
    static __CheckClean = function(_struct, _permittedNameArray)
    {
        var _namesArray = struct_get_names(_struct);
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            var _name = _namesArray[_i];
            
            if (array_get_index(_permittedNameArray, _name) < 0)
            {
                __Error($"Member variable \"{_name}\" not permitted in automation step (permitted={_permittedNameArray})");
                return false;
            }
            
            ++_i;
        }
        
        return true;
    }
}