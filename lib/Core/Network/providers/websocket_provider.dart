import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../websockets.dart';


final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(() => service.dispose());
  return service;
});

final webSocketConnectionProvider = StreamProvider<ConnectionStatus>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return webSocketService.statusStream;
});