// Feather disable all

/// @param sourcePath
/// @param destinationPath
/// @param [destroyDirectory=false]

function HotglueProjectToolConvert(_sourcePath, _destinationPath, _destroyDirectory = false)
{
    if (not HotglueGetProjectToolExists())
    {
        __HotglueWarning("Project tool not available, aborting");
        return false;
    }
    
    if (not file_exists(_sourcePath))
    {
        __HotglueWarning($"\"{_sourcePath}\" does not exist, aborting");
        return false;
    }
    
    if (file_exists(_destinationPath))
    {
        if (not _destroyDirectory)
        {
            __HotglueWarning($"\"{_destinationPath}\" already exists, aborting");
            return false;
        }
        
        var _destinationDirectory = filename_dir(_sourcePath);
        __HotglueWarning($"\"{_destinationPath}\" already exists, deleting directory \"{_destinationDirectory}\"");
    }
    
    var _projectToolPath = HotglueGetProjectToolPath();
    
    var _outputPath  = $"{game_save_id}cache/temp/batch-output.txt";
    var _triggerPath = $"{game_save_id}cache/temp/trigger.txt";
    file_delete(_outputPath);
    file_delete(_triggerPath);
    
    var _prefabsDirectory  = "C:/ProgramData/GameMakerStudio2/Prefabs";
    var _resourceTypesPath = "C:/Users/conta/AppData/Local/Temp/hotglue.tmp";
    var _convRoot          = "C:/Users/conta/AppData/Local/GameMakerStudio2/GMS2TEMP/ProjectTool";
    
    var _batchPath = $"{game_save_id}cache/temp/projecttool.bat";
    var _batchContent = "@echo off\n";
    _batchContent += "echo Running ProjectTool, please wait...\n";
    _batchContent += $"echo (Log can be found at {_outputPath})\n";
    _batchContent += $"\"{_projectToolPath}\" PROJECT SAVE SOURCE=\"{_sourcePath}\" DESTINATION=\"{_destinationPath}\" RESOURCETYPESPATH=\"{_resourceTypesPath}\" PREFABSFOLDER=\"{_prefabsDirectory}\" CONVROOT=\"{_convRoot}\" > \"{_outputPath}\"\n";
    _batchContent += $"echo done > \"{_triggerPath}\"\n";
    
    var _buffer = buffer_create(string_byte_length(_batchContent), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _batchContent);
    buffer_save(_buffer, _batchPath);
    buffer_delete(_buffer);
    
    __HotglueTrace($"Starting conversion of \"{_sourcePath}\" (log can be found at \"{_outputPath}\")");
    HotglueExecuteShell(_batchPath, "");
    
    var _result = false;
    var _time = current_time;
    
    var _checkpointTime = _time;
    var _checkpointCount = 0;
    while(true)
    {
        if (file_exists(_triggerPath))
        {
            __HotglueTrace($"Took {current_time - _time}ms");
            
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
            
            if (string_pos("ProjectTool Successful", _string) > 0)
            {
                __HotglueTrace($"Converted project and exported to \"{_destinationPath}\" successfully");
                _result = true;
            }
            else
            {
                __HotglueWarning($"ProjectTool failed to convert \"{_sourcePath}\"");
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
                __HotglueWarning("ProjectTool conversion timed out");
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

/*

ProjectTool+483dfd1289b84be5de5b3f4c09bf4df2e2d5f818
----------------------------------------------------
Available Commands:

CLI - Command Line Interface

SCRIPT - Process a scripted list of commands
--------------------------------------------
SCRIPT
        PATH = <Path to Script>

HELP - Display help
-------------------
HELP
        COMMAND = <Command name of interest> (Optional, default = ALL)

        Alternatively, you can use the syntax like 'HELP COMMAND SUBCOMMAND' to get subcommand help.

DEFAULTS - Set default arguments values
---------------------------------------
Show default argument value
        DEFAULTS GET

                Use like: DEFAULTS GET <Command> <SubCommand> <Argument>
Set default argument value
        DEFAULTS SET

                Use like: DEFAULTS SET <Command> <SubCommand> <Argument>=<Value>

JSON - JSON processing commands
-------------------------------
Apply GameMaker standard whitespace formatting to JSON file, and choose whether to have GameMaker-style commas or standard JSON commas.
        JSON FORMAT
                INPUT = <Path to UTF-8 JSON file to be formatted>
                OUTPUT = <Path to output file (can be same as INPUT).> (Optional)
                COMMAS = <Affects the output of commas. STANDARD gives regular JSON, GAMEMAKER is the default.> (Optional)

LINKS - Links commands
----------------------
Get a report of all the prefab links from the game project in a text file.
        LINKS GET
                SOURCE = <Path to Project YYP>
                OUTPUT = <Path and file name for the output links file.>
Attempt to apply altered prefab links to the game files.
        LINKS APPLY
                SOURCE = <Path to Project YYP to be altered>
                LINKSFILE = <Path and file name of the links file to be applied.>
Obtain a frequency table of all dependency links needed by the game.
        LINKS FREQUENCY
                SOURCE = <Path to Project YYP to scan>
Obtain a list of all Prefab dependency links needed by the game.
        LINKS LIST
                SOURCE = <Path to Project YYP to scan>
Obtain a list of all dependency Prefab libraries needed by the game.
        LINKS LIBS
                SOURCE = <Path to Project YYP to scan>

PROJECT - Project commands
--------------------------
Create a new project
        PROJECT NEW
                NAME = <Name of Project>
                DESTINATION = <Path to Save>
Open a project
        PROJECT OPEN
                SOURCE = <Path to Project YYP>
Close the currently opened project
        PROJECT CLOSE
Save a project
        PROJECT SAVE
                DESTINATION = <Path to Project YYP. Can be omitted to save in-place> (Optional)
                SOURCE = <Path to Source YYP. Can be omitted to save the project in memory> (Optional)

FILE - File commands
--------------------
Change the version of an individual VERSIONED-format YY or YYP file
        FILE CHANGEVERSION
                SOURCE = <Path to source YY or YYP file>
                DESTINATION = <Path to save updated file, or omit to save back over source file> (Optional)

IMPORT - Import commands
------------------------
Import a resource .YY into the current or given project
        IMPORT YY
                SOURCES = <Comma-separated paths to .YY files to import>
                DESTINATION = <Path to Project to Import into or omit for current Open project> (Optional)
                FOLDER = <Folder Path to add resource to, or omit for root of project> (Optional)

EXPORT - Export a project
-------------------------
EXPORT
        SOURCE = <Path to Source Project or omit to use current project> (Optional)
        DESTINATION = <Path to Destination>
        PACKAGETYPE = <Package Type: Project, Package, Prefab> (Optional, default = PACKAGE)
        PACKAGEID = <Package Id> (Optional)
        PACKAGENAME = <Package Name> (Optional)
        PACKAGEVERSION = <Package Version> (Optional)
        PACKAGEDESCRIPTION = <Package Description> (Optional)
        PUBLISHERNAME = <Publisher Name> (Optional)
        CERTIFICATEPATH = <Marketplace Certificate Path> (Optional)
        CERTIFICATEPASSWORD = <Marketplace Certificate Password> (Optional)
        INCLUDEFOLDERS = <Comma separated list of Folder Paths to include - and all Resources within> (Optional)
        EXCLUDEFOLDERS = <Comma separated list of Folder Paths to exclude - and all Resources within> (Optional)
        INCLUDERESOURCES = <Comma separated list of Resources to specifically include> (Optional)
        EXCLUDERESOURCES = <Comma separated list of Resources to specifically exclude> (Optional)
        POSTREMOVALS = <Comma separated list of paths to remove before packaging - can include files and folders> (Optional)
        PREFABASSETS = <Comma separated list of Assets to mark as Prefabs> (Optional)
        INCLUDEOPTIONS = <Comma separated list of Options to specifically include - use ALL to pull all Options in> (Optional)

VERSION - Displays the Version of this Tool

FORMATS - Display comma separated list of formats supported by ProjectTool

SIGNING - Signing commands
--------------------------
Sign a Prefab library project
        SIGNING CREATE
                CERTIFICATEPATH = <Marketplace Certificate Path> (Optional)
                CERTIFICATEPASSWORD = <Marketplace Certificate Password> (Optional)
                PUBLISHERNAME = <Publisher Name> (Optional)
Sign a Local Package
        SIGNING PACKAGE
                SOURCE = <Path to YYMPS or omit to sign current project> (Optional)
                DESTINATION = <Path to Export YYMPS or omit to overwrite Source> (Optional)
                CERTIFICATEPATH = <Marketplace Certificate Path>
                CERTIFICATEPASSWORD = <Marketplace Certificate Password>
Verify a certificate
        SIGNING VERIFY
                CERTIFICATEPATH = <Marketplace Certificate Path> (Optional)
                CERTIFICATEPASSWORD = <Marketplace Certificate Password> (Optional)
Validate a package
        SIGNING VALIDATE
                SOURCE = <Path to Package>

SHOWVERSIONEDTYPES - Save out a list of resource classes and version that are known to this release of ProjectTool
------------------------------------------------------------------------------------------------------------------
SHOWVERSIONEDTYPES
        DESTINATION = <Path to output file ( usually IDEVERSIONSLIST.json )>
        SOURCE = <Path to input CoreResources ( leave to use ProjectTool's latest )> (Optional)

EXIT - Exit the CLI or stop processing script

Global Arguments - Arguments available on all commands
------------------------------------------------------
Global Arguments
        CLEANUP = <Cleanup conversion folders> (Optional, default = TRUE)
        CONVROOT = <Root path to store CONV folders - defaults to *source project* / conv> (Optional, default = C:\Users\conta\AppData\Local\Temp\ProjectTool_1260992699)
        FORCEVERS0 = <Force VERS0 conversion where necessary - this is dangerous> (Optional, default = FALSE)
        FORMAT = <Format to convert to: LTS22, JUN23, AUG23, NOV23, VERSIONED> (Optional, default = VERSIONED)
        RESOURCETYPESPATH = <Path to resource types list json file, corresponding to the target IDE Version.> (Optional)
        PREFABSFOLDER = <Path to prefab library packages folder> (Optional)
        READONLY = <Ensures the initial loaded project is marked as Read Only> (Optional, default = TRUE)
        CASEINSENSITIVE = <Emulates case insensitive filesystem where necessary. TRUE by default on Linux, FALSE for other platforms.> (Optional)
Arguments must be defined unless optional, but can be in any order, and do not need to be specified upper case.
For Example:
        ProjectTool <Command> <SubCommand> <SubCommand> name=MyName DeStInAtIoN="/path/to/destination/file"
        
*/