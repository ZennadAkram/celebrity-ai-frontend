import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

final clientId = dotenv.env['CLIENT_ID_DISCORD'];
final clientSecret = dotenv.env['CLIENT_SECRET_DISCORD'];
const redirectUri = 'celebrityai://auth/callback'; // Mobile custom scheme
const scope = 'identify email';

Future<void> loginWithDiscord() async {
  try {
    print('🚀 Starting Discord OAuth...');

    final encodedRedirectUri = Uri.encodeComponent(redirectUri);
    final encodedScope = Uri.encodeComponent(scope);

    final authUrl =
        'https://discord.com/api/oauth2/authorize?client_id=$clientId&redirect_uri=$encodedRedirectUri&response_type=code&scope=$encodedScope';
    print('🔗 Auth URL: $authUrl');

    // Launch OAuth dialog
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: 'celebrityai',
    );

    print('✅ OAuth completed: $result');

    // Extract code from callback URL
    final uri = Uri.parse(result);
    final code = uri.queryParameters['code'];

    if (code == null) {
      print('❌ No code in response. Full URI: $uri');
      throw Exception('No code returned from Discord');
    }

    print('🔑 Authorization code: $code');

    // Exchange code for access token
    final tokenResponse = await Dio().post(
      'https://discord.com/api/oauth2/token',
      data: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    final discordAccessToken = tokenResponse.data['access_token'];
    if (discordAccessToken == null) throw Exception('No access token from Discord');

    print('✅ Discord login successful!');
    print('🛡️ Access Token: $discordAccessToken');

    // You can store the token securely
    await storage.write(key: 'discord_access_token', value: discordAccessToken);

  } catch (e) {
    print('❌ Discord login error: $e');
  }
}
