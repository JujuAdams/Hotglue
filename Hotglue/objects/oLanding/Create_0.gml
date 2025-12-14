// Feather disable all

LogTrace("Application booted");
LogTrace($"GM_build_type = \"{GM_build_type}\", debug_mode = {debug_mode}, os_type = {os_type}");

HotglueClearUnzipCache();

//TODO - CLI

LogTrace($"parameter_count = {parameter_count()}");
var _i = 0;
repeat(parameter_count())
{
    LogTrace($"parameter {_i} = {parameter_string(_i)}");
    ++_i;
}

instance_destroy();
instance_create_depth(0, 0, 0, oInterface);