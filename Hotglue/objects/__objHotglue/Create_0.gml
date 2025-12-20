// Feather disable all

// Create server to receive incoming HTTP requests as part of the web page authentication flow
__server = undefined;
__socket = undefined;

__udpSocket = network_create_socket_ext(network_socket_udp, 52500);
LogTrace($"UDP socket = {__udpSocket}");