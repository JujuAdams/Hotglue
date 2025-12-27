// Feather disable all

function HotglueURITest()
{
    static _system = __HotglueSystem();
    
    LogTraceAndStatus("Running URI test");
    _system.__uriTestTimeout = current_time + 5000;
    
    HotglueExecuteShell("hotglue://test/", "");
}