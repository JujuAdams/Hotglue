// Feather disable all

HotglueSetTraceHandler(InterfaceTrace);
HotglueSetWarningHandler(InterfaceWarning);

instance_create_depth(0, 0, 0, oHTTPRequestHandler);

//TODO - CLI

instance_destroy();
instance_create_depth(0, 0, 0, oInterface);