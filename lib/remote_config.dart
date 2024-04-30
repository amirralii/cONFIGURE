import 'package:firebase_remote_config/firebase_remote_config.dart';


Future<String> fetchStringConfig(Ref ref, {required String key}) async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getString(key);
  } catch (e) {
    print('Error fetching remote config: $e');
    throw e;
  }
}

class Ref {
  void refresh(fetchStringConfigStreamProvider) {}
}

Stream<String> fetchStringConfigStream(Ref ref, {required String key}) async* {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await remoteConfig.fetchAndActivate();
    yield remoteConfig.getString(key);
    remoteConfig.onConfigUpdated.listen((event) {
      ref.refresh(fetchStringConfigStreamProvider(key: key));
    });
  } catch (e) {
    print('Error fetching remote config stream: $e');
  }
}

fetchStringConfigStreamProvider({required String key}) {
}
