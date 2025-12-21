// Feather disable all

__selfDestructTimer = infinity;
__udpSendSocket = undefined;

LogTrace("Application booted");
LogTrace($"GM_build_type = \"{GM_build_type}\", debug_mode = {debug_mode}, os_type = {os_type}");

LogTrace($"parameter_count = {parameter_count()}");
var _i = 0;
repeat(parameter_count())
{
    LogTrace($"parameter {_i} = {parameter_string(_i)}");
    ++_i;
}

if (HOTGLUE_RUNNING_FROM_IDE || HotglueUDPPortIsOpen())
{
    HotglueClearUnzipCache();
}

var _openInterface  = HOTGLUE_RUNNING_FROM_IDE || HotglueUDPPortIsOpen();
var _runningFromURI = (not HOTGLUE_RUNNING_FROM_IDE) && (parameter_count() >= 2) && HotglueURICheckString(parameter_string(1));

if (_openInterface)
{
    instance_destroy();
    instance_create_depth(0, 0, 0, oInterface);
}
else
{
    __selfDestructTimer = current_time + 200;
}

if (_runningFromURI)
{
    var _uriString = parameter_string(1);
    LogTrace($"Receveived URI activation \"{_uriString}\"");
    
    if (_openInterface)
    {
        HotglueURIHandleString(_uriString);
    }
    else
    {
        __udpSendSocket = network_create_socket(network_socket_udp);
        
        var _buffer = buffer_create(string_byte_length(_uriString), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _uriString);
        network_send_udp(__udpSendSocket, "127.0.0.1", 52500, _buffer, buffer_get_size(_buffer));
        buffer_delete(_buffer);
    }
}