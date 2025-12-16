/// @param [path]

function HotglueProjectToolTest(_projectToolPath = HotglueGetProjectToolPath())
{
    if (not file_exists(_projectToolPath))
    {
        __HotglueWarning($"Path \"{_projectToolPath}\" does not exist");
        return false;
    }
    
    if (not HotglueGetExecuteShellAvailable())
    {
        __HotglueWarning($"execute_shell_simple() not available, cannot execute ProjectTool test. Presuming success");
        return true;
    }
    
    var _outputPath  = $"{game_save_id}cache/temp/batch-output.txt";
    var _triggerPath = $"{game_save_id}cache/temp/trigger.txt";
    file_delete(_outputPath);
    file_delete(_triggerPath);
    
    var _batchPath = $"{game_save_id}cache/temp/projecttool.bat";
    var _batchContent = "@echo on\n";
    _batchContent += "echo Testing ProjectTool, please wait...\n";
    _batchContent += $"echo (Log can be found at {_outputPath})\n";
    _batchContent += $"\"{_projectToolPath}\" VERSION > \"{_outputPath}\"\n";
    _batchContent += $"\"{_projectToolPath}\" VERSION\n";
    _batchContent += $"echo done > \"{_triggerPath}\"\n";
    
    var _buffer = buffer_create(string_byte_length(_batchContent), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _batchContent);
    buffer_save(_buffer, _batchPath);
    buffer_delete(_buffer);
    
    __HotglueTrace($"Starting ProjectTool test at \"{_projectToolPath}\" (log can be found at \"{_outputPath}\")");
    execute_shell_simple(_batchPath, "");
    
    var _result = false;
    var _time = current_time;
    
    var _checkpointTime = _time;
    var _checkpointCount = 0;
    while(true)
    {
        if (file_exists(_triggerPath))
        {
            __HotglueTrace($"ProjectTool executed, checking output \"{_outputPath}\"");
            
            var _string = "";
            
            try
            {
                var _buffer = buffer_load(_outputPath);
                var _string = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
            }
            catch(_error)
            {
                __HotglueWarning(json_stringify(_error, true));
                __HotglueWarning($"Failed to open \"{_outputPath}\"");
            }
            
            if (string_pos("ProjectTool Successful", _string) <= 0)
            {
                __HotglueTrace($"ProjectTool test completed successfully");
                _result = true;
            }
            else
            {
                __HotglueWarning($"ProjectTool did not output as expected");
                _result = false;
            }
            
            break;
        }
        
        if (current_time - _checkpointTime > 5000)
        {
            _checkpointTime += 5000;
            ++_checkpointCount;
            
            if (_checkpointCount >= 12)
            {
                __HotglueWarning("Test failed; timeout");
                break;
            }
            else
            {
                __HotglueTrace($"Waiting for ProjectTool to finish...");
            }
        }
    }
    
    file_delete(_triggerPath);
    file_delete(_batchPath);
    
    return _result;
}