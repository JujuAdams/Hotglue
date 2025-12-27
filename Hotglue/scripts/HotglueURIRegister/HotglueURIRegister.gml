// Feather disable all

/// @param path

function HotglueURIRegister()
{
    var _uriReceiverPath = parameter_string(0);
    _uriReceiverPath = string_replace_all(_uriReceiverPath, "\\", "\\\\");
    _uriReceiverPath = string_replace_all(_uriReceiverPath, "/", "\\\\");
    
	var _registryString = string_join("\n",
    "Windows Registry Editor Version 5.00",
	" ",
	"[HKEY_CLASSES_ROOT\\hotglue]",
	"@=\"URL:hotglue Protocol\"",
	"\"URL Protocol\"=\"\"",
	" ",
	"[HKEY_CLASSES_ROOT\\hotglue\\DefaultIcon]",
	"@=\"" + filename_name(_uriReceiverPath) + "\"",
	" ",
	"[HKEY_CLASSES_ROOT\\hotglue\\shell]",
	" ",
	"[HKEY_CLASSES_ROOT\\hotglue\\shell\\open]",
	" ",
	"[HKEY_CLASSES_ROOT\\hotglue\\shell\\open\\command]",
	"@=\"\\\"" + _uriReceiverPath + "\\\" \\\"%1\\\"\"");
    
    var _batchFileString = string_join("\n",
    "@echo off",
    "echo Adding Hotglue URI via Windows Registry",
    "REGEDIT.EXE /S %~dp0/uri-registration.reg");
    
    __HotglueSaveString($"{HOTGLUE_TEMP_CACHE_DIRECTORY}uri-registration.reg", _registryString);
	__HotglueSaveString($"{HOTGLUE_TEMP_CACHE_DIRECTORY}uri-registration.bat", _batchFileString);
    
    HotglueExecuteShell($"{HOTGLUE_TEMP_CACHE_DIRECTORY}uri-registration.bat", "");
}