import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'screens/orb_home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '349759064384-l8uvmt3stdv5cedif3fk50vg8ojqmrdr.apps.googleusercontent.com',
    );
  }

  runApp(const GideonApp());
}


class GideonLogo extends StatelessWidget {
  final double size;
  final double radius;

  const GideonLogo({
    super.key,
    required this.size,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF071A2C),
            Color(0xFF0A1326),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF5FE7FF).withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5FE7FF).withValues(alpha: 0.14),
            blurRadius: size * 0.24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _GideonLogoPainter(),
      ),
    );
  }
}

class _GideonLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final s = size.shortestSide;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.095
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF42E8FF),
          Color(0xFF2E9DFF),
          Color(0xFF8B63FF),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: s * 0.30),
      );

    final ringRect = Rect.fromCircle(
      center: center,
      radius: s * 0.30,
    );

    canvas.drawArc(
      ringRect,
      -2.55,
      4.65,
      false,
      ringPaint,
    );

    final gPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.10
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF5FE7FF),
          Color(0xFF6BA9FF),
          Color(0xFF9A69FF),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final gPath = Path()
      ..moveTo(center.dx + s * 0.22, center.dy + s * 0.02)
      ..lineTo(center.dx + s * 0.02, center.dy + s * 0.02)
      ..lineTo(center.dx + s * 0.02, center.dy + s * 0.22);

    canvas.drawPath(gPath, gPaint);

    final sparkle = Path();
    final sc = Offset(
      center.dx - s * 0.02,
      center.dy - s * 0.08,
    );
    final r1 = s * 0.14;
    final r2 = s * 0.035;

    for (int i = 0; i < 8; i++) {
      final angle = i * 3.1415926535 / 4;
      final r = i.isEven ? r1 : r2;
      final p = sc + Offset(
        r * 0.72 * math.cos(angle),
        r * math.sin(angle),
      );
      if (i == 0) {
        sparkle.moveTo(p.dx, p.dy);
      } else {
        sparkle.lineTo(p.dx, p.dy);
      }
    }
    sparkle.close();

    final sparklePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFB8F8FF);

    canvas.drawPath(sparkle, sparklePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _CoreOrbitPainter extends CustomPainter {
  final double opacity;

  _CoreOrbitPainter({
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = const Color(0xFF5FE7FF).withValues(alpha: opacity * 0.42);

    final ring2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0xFF8B63FF).withValues(alpha: opacity * 0.32);

    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.86,
      height: size.height * 0.36,
    );

    canvas.drawOval(rect, ring);
    canvas.save();
    canvas.rotate(-0.72);
    canvas.drawOval(rect, ring2);
    canvas.restore();

    final tick = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF5FE7FF).withValues(alpha: opacity * 0.75);

    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final inner = Offset(
        center.dx + math.cos(a) * size.width * 0.43,
        center.dy + math.sin(a) * size.height * 0.43,
      );
      final outer = Offset(
        center.dx + math.cos(a) * size.width * 0.46,
        center.dy + math.sin(a) * size.height * 0.46,
      );
      canvas.drawLine(inner, outer, tick);
    }
  }

  @override
  bool shouldRepaint(covariant _CoreOrbitPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

class GideonSettings extends ChangeNotifier {
  GideonSettings._();
  static final GideonSettings instance = GideonSettings._();

  ThemeMode themeMode = ThemeMode.dark;
  Color accentColor = const Color(0xFF5FE7FF);
  String language = 'العربية';
  bool notificationsEnabled = true;
  bool chatHistoryEnabled = true;
  String username = 'Daniel';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme_mode');
    if (theme == 'light') {
      themeMode = ThemeMode.light;
    } else if (theme == 'system') {
      themeMode = ThemeMode.system;
    } else {
      themeMode = ThemeMode.dark;
    }
    language = prefs.getString('language') ?? 'العربية';
    notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    chatHistoryEnabled = prefs.getBool('chat_history_enabled') ?? true;
    username = prefs.getString('username') ?? 'Daniel';
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_mode',
      value == ThemeMode.light
          ? 'light'
          : value == ThemeMode.system
              ? 'system'
              : 'dark',
    );
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    language = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    notifyListeners();
  }

  Future<void> setChatHistory(bool value) async {
    chatHistoryEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('chat_history_enabled', value);
    notifyListeners();
  }

  Future<void> setUsername(String value) async {
    username = value.trim().isEmpty ? 'Daniel' : value.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    notifyListeners();
  }
}

class GideonApp extends StatefulWidget {
  const GideonApp({super.key});

  @override
  State<GideonApp> createState() => _GideonAppState();
}

class _GideonAppState extends State<GideonApp> {
  final GideonSettings _settings = GideonSettings.instance;

  @override
  void initState() {
    super.initState();
    _settings.load().then((_) {
      if (mounted) setState(() {});
    });
  }

  ThemeData _theme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? const Color(0xFF07111F)
          : const Color(0xFFF5F7FA),
      colorScheme: ColorScheme.fromSeed(
        seedColor: _settings.accentColor,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xFF07111F)
            : const Color(0xFFF5F7FA),
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'Gideon',
          debugShowCheckedModeBanner: false,
          theme: _theme(Brightness.light),
          darkTheme: _theme(Brightness.dark),
          themeMode: _settings.themeMode,
          builder: (context, child) {
            return Directionality(
              textDirection: _settings.language == 'English'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const AppGate(),
        );
      },
    );
  }
}

// ============================================================
// APP GATE
// ============================================================

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  bool _loading = true;
  String? _token;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('jwt_token');
    final email = prefs.getString('email');

    if (token == null || token.isEmpty) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      return;
    }

    // Verify token with backend.
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://my-ai-server-3-se3x.onrender.com/me',
            ),
            headers: {
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 30),
          );

      if (response.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          _token = token;
          _email = email;
          _loading = false;
        });

        return;
      }

      if (response.statusCode == 401) {
        await prefs.remove('jwt_token');
        await prefs.remove('email');

        if (!mounted) return;

        setState(() {
          _token = null;
          _email = null;
          _loading = false;
        });

        return;
      }

      // Keep the session for server-side or transient failures.
      if (!mounted) return;

      setState(() {
        _token = token;
        _email = email;
        _loading = false;
      });
    } catch (_) {
      // Network/timeout failures must not log the user out.
      if (!mounted) return;

      setState(() {
        _token = token;
        _email = email;
        _loading = false;
      });
    }
  }

  Future<void> _onAuthenticated(
    String token,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'jwt_token',
      token,
    );

    await prefs.setString(
      'email',
      email,
    );

    if (!mounted) return;

    setState(() {
      _token = token;
      _email = email;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await FirebaseAuth.instance.signOut();
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (_) {
      // Local Gideon session logout should still complete.
    }

    await prefs.remove('jwt_token');
    await prefs.remove('email');

    if (!mounted) return;

    setState(() {
      _token = null;
      _email = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SplashScreen();
    }

    if (_token == null || _token!.isEmpty) {
      return AuthScreen(
        onAuthenticated: _onAuthenticated,
      );
    }

    return OrbHomeScreen(
      onOpenMenu: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              token: _token!,
              email: _email ?? '',
              onLogout: _logout,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// SPLASH
// ============================================================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF07111F),
              Color(0xFF0B1830),
              Color(0xFF07111F),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GideonLogo(size: 110.0, radius: 28.0),
              const SizedBox(height: 22),
              const Text(
                'Gideon',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 25),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// AUTH
// ============================================================

class AuthScreen extends StatefulWidget {
  final Future<void> Function(
    String token,
    String email,
  ) onAuthenticated;

  const AuthScreen({
    super.key,
    required this.onAuthenticated,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const String baseUrl =
      'https://my-ai-server-3-se3x.onrender.com';

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(
    String message, {
    bool error = true,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error
            ? const Color(0xFF9D253B)
            : const Color(0xFF157C66),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      UserCredential credential;

      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        credential = await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        if (!GoogleSignIn.instance.supportsAuthenticate()) {
          _showMessage(
            'تسجيل الدخول عبر Google غير متاح على هذه المنصة حاليًا.',
          );
          return;
        }

        final googleUser = await GoogleSignIn.instance.authenticate();
        final googleAuth = googleUser.authentication;

        final idToken = googleAuth.idToken;
        if (idToken == null || idToken.isEmpty) {
          _showMessage(
            'تعذر الحصول على رمز Google. حاول مرة أخرى.',
          );
          return;
        }

        final firebaseCredential = GoogleAuthProvider.credential(
          idToken: idToken,
        );

        credential = await FirebaseAuth.instance.signInWithCredential(
          firebaseCredential,
        );
      }

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        _showMessage('تعذر إتمام تسجيل الدخول عبر Google.');
        return;
      }

      final firebaseIdToken = await firebaseUser.getIdToken();
      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        _showMessage('تعذر الحصول على رمز Firebase.');
        return;
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/google'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'id_token': firebaseIdToken,
            }),
          )
          .timeout(const Duration(seconds: 60));

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['token']?.toString();
        final responseEmail =
            data['email']?.toString() ?? firebaseUser.email ?? '';

        if (token == null || token.isEmpty) {
          _showMessage('السيرفر لم يرجع رمز تسجيل الدخول.');
          return;
        }

        await widget.onAuthenticated(token, responseEmail);
        return;
      }

      _showMessage(
        data['error']?.toString() ??
            'تعذر تسجيل الدخول عبر Google.',
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'popup-closed-by-user' ||
          error.code == 'cancelled-popup-request') {
        return;
      }

      _showMessage(
        error.message ?? 'فشل تسجيل الدخول عبر Google.',
      );
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return;
      }

      _showMessage('تعذر تسجيل الدخول عبر Google. حاول مرة أخرى.');
    } catch (_) {
      _showMessage(
        'تعذر الاتصال بخدمة تسجيل الدخول. حاول مرة أخرى بعد قليل.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(
        'يرجى إدخال البريد الإلكتروني وكلمة المرور.',
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage(
        'يرجى إدخال بريد إلكتروني صحيح.',
      );
      return;
    }

    if (password.length < 8) {
      _showMessage(
        'كلمة المرور يجب أن تكون 8 أحرف على الأقل.',
      );
      return;
    }

    if (!_isLogin) {
      final confirmPassword =
          _confirmPasswordController.text;

      if (password != confirmPassword) {
        _showMessage(
          'كلمتا المرور غير متطابقتين.',
        );
        return;
      }
    }

    setState(() {
      _loading = true;
    });

    try {
      final endpoint = _isLogin
          ? '$baseUrl/login'
          : '$baseUrl/register';

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(
            const Duration(seconds: 120),
          );

      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final token = data['token']?.toString();

        final responseEmail =
            data['email']?.toString() ?? email;

        if (token == null || token.isEmpty) {
          _showMessage(
            'السيرفر لم يرجع رمز تسجيل الدخول.',
          );
          return;
        }

        await widget.onAuthenticated(
          token,
          responseEmail,
        );

        return;
      }

      final message = data['error']?.toString() ??
          'حدث خطأ غير معروف.';

      _showMessage(message);
         } catch (_) {
      if (!mounted) return;

      _showMessage(
        'تعذر الاتصال بخدمة تسجيل الدخول. حاول مرة أخرى بعد قليل.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF07111F),
              Color(0xFF0B1A30),
              Color(0xFF10132A),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 30,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 480,
                ),
                child: Column(
                  children: [
                    GideonLogo(size: 105.0, radius: 28.0),
                    const SizedBox(height: 18),
                    const Text(
                      'Gideon',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? 'مرحبًا بعودتك'
                          : 'أنشئ حسابك الجديد',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.055,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.09,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            textInputAction:
                                TextInputAction.next,
                            decoration: _inputDecoration(
                              label: 'البريد الإلكتروني',
                              icon: Icons.email_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            textInputAction: _isLogin
                                ? TextInputAction.done
                                : TextInputAction.next,
                            onSubmitted: (_) {
                              if (_isLogin) {
                                _submit();
                              }
                            },
                            decoration: _inputDecoration(
                              label: 'كلمة المرور',
                              icon: Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hidePassword =
                                        !_hidePassword;
                                  });
                                },
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                          ),
                          if (!_isLogin) ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller:
                                  _confirmPasswordController,
                              obscureText: _hidePassword,
                              textInputAction:
                                  TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                              decoration: _inputDecoration(
                                label: 'تأكيد كلمة المرور',
                                icon: Icons.lock_reset_outlined,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: FilledButton(
                              onPressed:
                                  _loading ? null : _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF59DDF8),
                                foregroundColor:
                                    const Color(0xFF06131D),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 23,
                                      height: 23,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      _isLogin
                                          ? 'تسجيل الدخول'
                                          : 'إنشاء الحساب',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'أو',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        onPressed: _loading ? null : _signInWithGoogle,
                        icon: const Icon(Icons.account_circle_outlined),
                        label: const Text(
                          'المتابعة باستخدام Google',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () {
                              setState(() {
                                _isLogin = !_isLogin;
                                _confirmPasswordController
                                    .clear();
                              });
                            },
                      child: Text(
                        _isLogin
                            ? 'ليس لديك حساب؟ إنشاء حساب'
                            : 'لديك حساب بالفعل؟ تسجيل الدخول',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.black.withValues(
        alpha: 0.17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withValues(
            alpha: 0.07,
          ),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF5FE7FF),
        ),
      ),
    );
  }
}

// ============================================================
// CHAT MESSAGE
// ============================================================

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class Conversation {
  final int id;
  String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Conversation({
    required this.id,
    required this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: int.parse(json['id'].toString()),
      title: json['title']?.toString() ?? 'New Chat',
      createdAt: DateTime.tryParse(
        json['created_at']?.toString() ?? '',
      ),
      updatedAt: DateTime.tryParse(
        json['updated_at']?.toString() ?? '',
      ),
    );
  }
}


// ============================================================
// GIDEON PRO
// ============================================================

class ProProduct {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String billingPeriod;
  final String status;
  final Map<String, dynamic> paymentChannels;

  const ProProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.billingPeriod,
    required this.status,
    required this.paymentChannels,
  });

  factory ProProduct.fromJson(Map<String, dynamic> json) {
    return ProProduct(
      id: json['id']?.toString() ?? 'gideon_pro_monthly',
      name: json['name']?.toString() ?? 'Gideon Pro',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 4.99,
      currency: json['currency']?.toString() ?? 'USD',
      billingPeriod: json['billing_period']?.toString() ?? 'month',
      status: json['status']?.toString() ?? 'coming_soon',
      paymentChannels: Map<String, dynamic>.from(
        json['payment_channels'] is Map
            ? json['payment_channels'] as Map
            : const {},
      ),
    );
  }
}


class ChangePasswordDialog extends StatefulWidget {
  final String token;

  const ChangePasswordDialog({
    super.key,
    required this.token,
  });

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  static const String _baseUrl =
      'https://my-ai-server-3-se3x.onrender.com';

  late final TextEditingController _currentController;
  late final TextEditingController _newController;
  late final TextEditingController _confirmController;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _currentController = TextEditingController();
    _newController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submit() async {
    if (_loading) return;

    final current = _currentController.text;
    final next = _newController.text;
    final confirm = _confirmController.text;

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      _showError('يرجى تعبئة جميع الحقول.');
      return;
    }

    if (next.length < 8) {
      _showError(
        'كلمة المرور الجديدة يجب أن تكون 8 أحرف على الأقل.',
      );
      return;
    }

    if (next != confirm) {
      _showError('كلمتا المرور غير متطابقتين.');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/change-password'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${widget.token}',
            },
            body: jsonEncode({
              'current_password': current,
              'new_password': next,
            }),
          )
          .timeout(const Duration(seconds: 60));

      final data = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(
              utf8.decode(response.bodyBytes),
            ) as Map<String, dynamic>;

      if (!mounted) return;

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
        return;
      }

      setState(() {
        _loading = false;
      });

      _showError(
        data['error']?.toString() ??
            'تعذر تغيير كلمة المرور.',
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showError(
        'تعذر الاتصال بالخادم. حاول مرة أخرى.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تغيير كلمة المرور'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentController,
              obscureText: _obscureCurrent,
              enabled: !_loading,
              decoration: InputDecoration(
                labelText: 'كلمة المرور الحالية',
                suffixIcon: IconButton(
                  onPressed: _loading
                      ? null
                      : () {
                          setState(() {
                            _obscureCurrent = !_obscureCurrent;
                          });
                        },
                  icon: Icon(
                    _obscureCurrent
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newController,
              obscureText: _obscureNew,
              enabled: !_loading,
              decoration: InputDecoration(
                labelText: 'كلمة المرور الجديدة',
                suffixIcon: IconButton(
                  onPressed: _loading
                      ? null
                      : () {
                          setState(() {
                            _obscureNew = !_obscureNew;
                          });
                        },
                  icon: Icon(
                    _obscureNew
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              obscureText: _obscureConfirm,
              enabled: !_loading,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'تأكيد كلمة المرور الجديدة',
                suffixIcon: IconButton(
                  onPressed: _loading
                      ? null
                      : () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                  ),
                )
              : const Text('تغيير'),
        ),
      ],
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final String token;
  final String email;

  const SettingsScreen({
    super.key,
    required this.token,
    required this.email,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GideonSettings _settings = GideonSettings.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settings,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'الإعدادات',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
            children: [
              _sectionTitle('الحساب'),
              _card([
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded),
                  title: const Text('اسم المستخدم'),
                  subtitle: Text(_settings.username),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: _editUsername,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('البريد الإلكتروني'),
                  subtitle: Text(
                    widget.email,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline_rounded),
                  title: const Text('تغيير كلمة المرور'),
                  subtitle: const Text('تحديث كلمة مرور حساب Gideon'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: _changePassword,
                ),
              ]),
              const SizedBox(height: 18),
              _sectionTitle('التخصيص'),
              _card([
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('المظهر'),
                  subtitle: Text(_themeLabel(_settings.themeMode)),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: _chooseTheme,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('اللغة'),
                  subtitle: Text(_settings.language),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: _chooseLanguage,
                ),
              ]),
              const SizedBox(height: 18),
              _sectionTitle('المحادثات والبيانات'),
              _card([
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.history_rounded),
                  title: const Text('حفظ سجل المحادثات'),
                  subtitle: const Text('التحكم بحفظ المحادثات السابقة'),
                  value: _settings.chatHistoryEnabled,
                  onChanged: _settings.setChatHistory,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: const Text('إدارة البيانات'),
                  subtitle: const Text('حذف وإدارة بيانات الحساب'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: _showDataManagement,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security_outlined),
                  title: const Text('الخصوصية والأمان'),
                  subtitle: const Text('معلومات حول حماية حسابك'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: _showPrivacy,
                ),
              ]),
              const SizedBox(height: 18),
              _sectionTitle('الإشعارات'),
              _card([
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.notifications_none_rounded),
                  title: const Text('الإشعارات'),
                  subtitle: const Text('السماح بإشعارات Gideon'),
                  value: _settings.notificationsEnabled,
                  onChanged: _settings.setNotifications,
                ),
              ]),
              const SizedBox(height: 18),
              _sectionTitle('Gideon'),
              _card([
                ListTile(
                  leading: const Icon(Icons.auto_awesome_rounded),
                  title: const Text('Gideon Pro'),
                  subtitle: const Text('\$4.99 / month • قريبًا'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProScreen(token: widget.token),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('موقع Gideon'),
                  subtitle: const Text('gideonassistant.uk'),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 19),
                  onTap: () => launchUrl(
                    Uri.parse('https://gideonassistant.uk'),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('حول Gideon'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Gideon',
                    applicationVersion: '1.0.0',
                    applicationIcon: const GideonLogo(
                      size: 54,
                      radius: 15,
                    ),
                    children: const [
                      Text(
                        'مساعد ذكاء اصطناعي تم تطويره بواسطة Daniel.',
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'فاتح';
      case ThemeMode.system:
        return 'حسب النظام';
      case ThemeMode.dark:
        return 'داكن';
    }
  }

  Future<void> _editUsername() async {
    final controller = TextEditingController(text: _settings.username);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغيير اسم المستخدم'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(
            labelText: 'اسم المستخدم',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null && value.trim().isNotEmpty) {
      await _settings.setUsername(value);
    }
  }

  Future<void> _chooseTheme() async {
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: RadioGroup<ThemeMode>(
          groupValue: _settings.themeMode,
          onChanged: (value) {
            if (value != null) {
              Navigator.pop(context, value);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                title: Text('داكن'),
              ),
              const RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                title: Text('فاتح'),
              ),
              const RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                title: Text('حسب النظام'),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected != null) {
      await _settings.setThemeMode(selected);
    }
  }

  Future<void> _chooseLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇱🇧'),
              title: const Text('العربية'),
              trailing: _settings.language == 'العربية'
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.pop(context, 'العربية'),
            ),
            ListTile(
              leading: const Text('🇺🇸'),
              title: const Text('English'),
              trailing: _settings.language == 'English'
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.pop(context, 'English'),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      await _settings.setLanguage(selected);
    }
  }

  Future<void> _changePassword() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ChangePasswordDialog(
        token: widget.token,
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تغيير كلمة المرور بنجاح. 🔐'),
        ),
      );
    }
  }

  void _showDataManagement() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إدارة البيانات'),
        content: const Text(
          'إدارة وحذف بيانات الحساب ستكون متاحة هنا ضمن أدوات البيانات القادمة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showPrivacy() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الخصوصية والأمان'),
        content: const Text(
          'يتم إرسال البيانات إلى خادم Gideon عبر اتصال مشفّر. يمكنك مراجعة سياسة الخصوصية من موقع Gideon.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  final String token;
  final String email;

  const AccountScreen({
    super.key,
    required this.token,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final settings = GideonSettings.instance;

    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'الحساب',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    child: Icon(Icons.person_rounded, size: 44),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    settings.username,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: const Text('حالة الحساب'),
                    subtitle: const Text('الحساب نشط'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.workspace_premium_outlined),
                    title: Text('الخطة الحالية'),
                    subtitle: Text('Gideon Free'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProScreen(token: token),
                ),
              ),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('استكشف Gideon Pro'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    token: token,
                    email: email,
                  ),
                ),
              ),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('فتح الإعدادات'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProScreen extends StatefulWidget {
  final String token;

  const ProScreen({
    super.key,
    required this.token,
  });

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  static const String baseUrl =
      'https://my-ai-server-3-se3x.onrender.com';

  static const String _proProductId = 'gideon_pro_monthly';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  ProProduct _product = const ProProduct(
    id: _proProductId,
    name: 'Gideon Pro',
    price: 4.99,
    currency: 'USD',
    billingPeriod: 'month',
    status: 'coming_soon',
    paymentChannels: {},
  );

  ProductDetails? _storeProduct;
  bool _loading = true;
  bool _storeLoading = true;
  bool _purchasePending = false;
  bool _storeAvailable = false;

  @override
  void initState() {
    super.initState();

    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () {
        _purchaseSubscription?.cancel();
      },
      onError: (Object error) {
        if (!mounted) return;
        setState(() => _purchasePending = false);
        _showMessage(
          'صار خطأ أثناء متابعة عملية الدفع. حاول مرة ثانية.',
        );
      },
    );

    _loadProduct();
    _loadStoreProduct();
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadProduct() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products/pro'))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data is Map<String, dynamic> && mounted) {
          setState(() {
            _product = ProProduct.fromJson(data);
            _loading = false;
          });
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadStoreProduct() async {
    try {
      final available = await _inAppPurchase.isAvailable();

      if (!available) {
        if (!mounted) return;
        setState(() {
          _storeAvailable = false;
          _storeLoading = false;
        });
        return;
      }

      final response = await _inAppPurchase.queryProductDetails(
        {_proProductId},
      );

      if (!mounted) return;

      setState(() {
        _storeAvailable = true;
        _storeLoading = false;
        _storeProduct = response.productDetails.isEmpty
            ? null
            : response.productDetails.first;
      });

      if (response.notFoundIDs.contains(_proProductId)) {
        _showMessage(
          'منتج Gideon Pro لسه مش مضاف على Google Play.',
          error: false,
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _storeAvailable = false;
        _storeLoading = false;
        _storeProduct = null;
      });
    }
  }

  Future<void> _buyPro() async {
    if (_purchasePending) return;

    final storeProduct = _storeProduct;

    if (!_storeAvailable || storeProduct == null) {
      _showMessage(
        'Gideon Pro لسه مش متاح للشراء من Google Play.',
        error: false,
      );
      return;
    }

    if (_product.status != 'available') {
      _showMessage(
        'Gideon Pro لسه قيد التجهيز. 🚀',
        error: false,
      );
      return;
    }

    setState(() => _purchasePending = true);

    try {
      final purchaseParam = PurchaseParam(
        productDetails: storeProduct,
      );

      final started = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!started && mounted) {
        setState(() => _purchasePending = false);
        _showMessage('تعذر بدء عملية الدفع.');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _purchasePending = false);
      _showMessage(
        'تعذر بدء عملية الدفع. حاول مرة ثانية.',
      );
    }
  }

  Future<void> _onPurchaseUpdated(
    List<PurchaseDetails> purchases,
  ) async {
    for (final purchase in purchases) {
      if (purchase.productID != _proProductId) continue;

      if (purchase.status == PurchaseStatus.pending) {
        if (mounted) {
          setState(() => _purchasePending = true);
        }
        continue;
      }

      if (purchase.status == PurchaseStatus.error) {
        if (mounted) {
          setState(() => _purchasePending = false);
        }
        _showMessage(
          'عملية الدفع ما اكتملت. حاول مرة ثانية.',
        );
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (mounted) {
          setState(() => _purchasePending = false);
        }

        // لا نفعّل Pro من التطبيق مباشرة.
        // لاحقًا نرسل بيانات الشراء للـ backend
        // ليتحقق من Google Play قبل تفعيل Pro.
        _showMessage(
          'تم استلام عملية الشراء. التفعيل النهائي يحتاج تحقق السيرفر. 🔐',
          error: false,
        );
      }

      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  void _showComingSoon() {
    _showMessage(
      'Gideon Pro لسه قيد التجهيز. 🚀',
      error: false,
    );
  }

  void _showMessage(
    String message, {
    bool error = true,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error
            ? const Color(0xFF9D253B)
            : const Color(0xFF157C66),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _channelStatus(String key, String fallback) {
    final value = _product.paymentChannels[key]?.toString();

    if (value == null || value.isEmpty) return fallback;

    switch (value) {
      case 'coming_soon':
        return 'قريبًا';
      case 'pending_merchant_integration':
        return 'قيد التجهيز';
      case 'available':
        return 'متاح';
      default:
        return fallback;
    }
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: const Color(0xFF5FE7FF)
                  .withValues(alpha: 0.09),
              border: Border.all(
                color: const Color(0xFF5FE7FF)
                    .withValues(alpha: 0.15),
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF5FE7FF),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.52),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentChannel({
    required IconData icon,
    required String title,
    required String status,
  }) {
    final active = status == 'متاح';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.065),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: active
                ? const Color(0xFF5FE7FF)
                : Colors.white.withValues(alpha: 0.55),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: active
                  ? const Color(0xFF5FE7FF)
                  : Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGooglePlayStatus() {
    String text;
    IconData icon;

    if (_storeLoading) {
      text = 'جارٍ فحص Google Play...';
      icon = Icons.sync_rounded;
    } else if (!_storeAvailable) {
      text = 'Google Play غير متاح حاليًا';
      icon = Icons.cloud_off_rounded;
    } else if (_storeProduct == null) {
      text = 'المنتج غير منشور بعد';
      icon = Icons.inventory_2_outlined;
    } else {
      text = 'منتج Google Play جاهز';
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF5FE7FF),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final price = _storeProduct?.price ??
        '\$${_product.price.toStringAsFixed(2)}';

    final canPurchase = !_storeLoading &&
        _storeAvailable &&
        _storeProduct != null &&
        _product.status == 'available' &&
        !_purchasePending;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gideon Pro',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF07111F),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF07111F),
              Color(0xFF0A1526),
              Color(0xFF07111F),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF102A42),
                        Color(0xFF151D3D),
                        Color(0xFF10162A),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF5FE7FF)
                          .withValues(alpha: 0.20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5FE7FF)
                            .withValues(alpha: 0.08),
                        blurRadius: 35,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF5FE7FF)
                              .withValues(alpha: 0.08),
                          border: Border.all(
                            color: const Color(0xFF5FE7FF)
                                .withValues(alpha: 0.20),
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 39,
                          color: Color(0xFF5FE7FF),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'GIDEON PRO',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF5FE7FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'خلّي Gideon يشتغل معك أكثر.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_loading)
                        const SizedBox(
                          height: 45,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      else
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: price,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF5FE7FF),
                                ),
                              ),
                              TextSpan(
                                text: ' / month',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white
                                      .withValues(alpha: 0.52),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'اشتراك شهري بسيط وواضح',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.48),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'شو بتحصل مع Pro؟',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildFeature(
                  icon: Icons.bolt_rounded,
                  title: 'حتى 200 رسالة باليوم',
                  subtitle:
                      'بدل حد الاستخدام اليومي المجاني الأقل.',
                ),
                _buildFeature(
                  icon: Icons.auto_awesome_rounded,
                  title: 'قدرات متقدمة',
                  subtitle:
                      'ميزات وقدرات جديدة عند إطلاقها رسميًا.',
                ),
                _buildFeature(
                  icon: Icons.rocket_launch_rounded,
                  title: 'أولوية للميزات الجديدة',
                  subtitle:
                      'الوصول إلى الميزات الجديدة حسب توفرها.',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: canPurchase
                        ? _buyPro
                        : (_purchasePending
                            ? null
                            : _showComingSoon),
                    icon: _purchasePending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            canPurchase
                                ? Icons.shopping_cart_checkout_rounded
                                : Icons.lock_clock_rounded,
                          ),
                    label: Text(
                      _purchasePending
                          ? 'جاري معالجة الدفع...'
                          : canPurchase
                              ? 'اشترك بـ Gideon Pro'
                              : 'الترقية إلى Pro قريبًا',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF5FE7FF),
                      foregroundColor: const Color(0xFF06131D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                  ),
                ),
                _buildGooglePlayStatus(),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'طرق الدفع',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildPaymentChannel(
                  icon: Icons.android_rounded,
                  title: 'Google Play',
                  status: _channelStatus(
                    'google_play',
                    'قريبًا',
                  ),
                ),
                const SizedBox(height: 9),
                _buildPaymentChannel(
                  icon: Icons.apple_rounded,
                  title: 'Apple App Store',
                  status: _channelStatus(
                    'apple_app_store',
                    'قريبًا',
                  ),
                ),
                const SizedBox(height: 9),
                _buildPaymentChannel(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Whish Pay',
                  status: _channelStatus(
                    'whish_pay',
                    'قيد التجهيز',
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.035),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: Color(0xFF5FE7FF),
                        size: 22,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          'الدفع الحقيقي رح يتم عبر قناة الدفع الرسمية، '
                          'والـ backend هو مصدر الحقيقة لصلاحية Pro. '
                          'ما رح نفعّل الاشتراك من داخل التطبيق بشكل غير آمن.',
                          style: TextStyle(
                            color: Colors.white
                                .withValues(alpha: 0.56),
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CHAT SCREEN
// ============================================================

class ChatScreen extends StatefulWidget {
  final String token;
  final String email;
  final Future<void> Function() onLogout;

  const ChatScreen({
    super.key,
    required this.token,
    required this.email,
    required this.onLogout,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  static const String baseUrl =
      'https://my-ai-server-3-se3x.onrender.com';

  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  final List<ChatMessage> _messages = [];
  final List<Conversation> _conversations = [];

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;
  PlatformFile? _selectedFile;

  bool _sending = false;
  bool _loadingHistory = true;
  int? _currentConversationId;
  late final AnimationController _coreController;

  Map<String, String> get _authHeaders {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };
  }

  Map<String, String> get _multipartHeaders {
    return {
      'Authorization': 'Bearer ${widget.token}',
    };
  }

  @override
  void initState() {
    super.initState();
    _coreController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _loadConversations();
  }

  @override
  void dispose() {
    _coreController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showMessage(
    String message, {
    bool error = true,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error
            ? const Color(0xFF9D253B)
            : const Color(0xFF157C66),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool> _handleUnauthorized() async {
    if (!mounted) return false;

    _showMessage(
      'انتهت جلسة تسجيل الدخول. يرجى تسجيل الدخول مرة أخرى.',
    );

    await widget.onLogout();
    return false;
  }

  Future<void> _loadConversations() async {
    if (mounted) {
      setState(() {
        _loadingHistory = true;
      });
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/conversations'),
            headers: _authHeaders,
          )
          .timeout(
            const Duration(seconds: 60),
          );

      if (response.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }

      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode != 200) {
        throw Exception(
          data['error']?.toString() ??
              'تعذر تحميل المحادثات.',
        );
      }

      final items = (data['conversations'] as List? ?? [])
          .map(
            (item) => Conversation.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        _conversations
          ..clear()
          ..addAll(items);
        _loadingHistory = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingHistory = false;
      });

      _showMessage(
        'تعذر تحميل المحادثات السابقة.',
      );
    }
  }

  Future<void> _createNewConversation({
    bool closeDrawer = false,
  }) async {
    if (_sending) return;

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/conversations'),
            headers: _authHeaders,
          )
          .timeout(
            const Duration(seconds: 60),
          );

      if (response.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }

      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode != 201) {
        throw Exception(
          data['error']?.toString() ??
              'تعذر إنشاء محادثة جديدة.',
        );
      }

      final conversation = Conversation.fromJson(
        Map<String, dynamic>.from(data['conversation']),
      );

      if (!mounted) return;

      setState(() {
        _currentConversationId = conversation.id;
        _messages.clear();

        _conversations.removeWhere(
          (item) => item.id == conversation.id,
        );
        _conversations.insert(0, conversation);
      });

      if (closeDrawer) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'تعذر إنشاء محادثة جديدة.',
      );
    }
  }

  Future<void> _loadConversation(
    Conversation conversation,
  ) async {
    Navigator.of(context).pop();

    setState(() {
      _currentConversationId = conversation.id;
      _messages.clear();
      _sending = false;
    });

    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/conversations/${conversation.id}/messages',
            ),
            headers: _authHeaders,
          )
          .timeout(
            const Duration(seconds: 60),
          );

      if (response.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }

      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode != 200) {
        throw Exception(
          data['error']?.toString() ??
              'تعذر تحميل المحادثة.',
        );
      }

      final messages = (data['messages'] as List? ?? [])
          .map(
            (item) => ChatMessage(
              text: item['content']?.toString() ?? '',
              isUser: item['role']?.toString() == 'user',
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        _messages
          ..clear()
          ..addAll(messages);
      });

      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'تعذر تحميل هذه المحادثة.',
      );
    }
  }

  Future<void> _showAttachmentMenu() async {
    if (_sending || !mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0B1728),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                _attachmentActionTile(
                  icon: Icons.camera_alt_outlined,
                  title: 'التقاط صورة',
                  subtitle: 'استخدم كاميرا الجهاز',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 8),
                _attachmentActionTile(
                  icon: Icons.photo_library_outlined,
                  title: 'اختيار صورة',
                  subtitle: 'من معرض الصور',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 8),
                _attachmentActionTile(
                  icon: Icons.attach_file_rounded,
                  title: 'اختيار ملف',
                  subtitle: 'PDF وملفات مدعومة أخرى',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickFile();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _attachmentActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      tileColor: Colors.white.withValues(alpha: 0.045),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF5FE7FF).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF5FE7FF),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 11,
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_sending) return;

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (image == null || !mounted) return;

      setState(() {
        _selectedImage = image;
        _selectedFile = null;
      });
    } catch (_) {
      if (!mounted) return;
      _showMessage('تعذر اختيار الصورة. تأكد من صلاحيات الكاميرا أو الصور.');
    }
  }

  Future<void> _pickFile() async {
    if (_sending) return;

    try {
      final files = await FilePicker.pickFiles();

      if (files.isEmpty || !mounted) return;

      final file = files.first;

      if (file.path == null || file.path!.isEmpty) {
        _showMessage('تعذر الوصول إلى الملف من الجهاز. اختر ملفًا آخر.');
        return;
      }

      setState(() {
        _selectedFile = file;
        _selectedImage = null;
      });
    } catch (_) {
      if (!mounted) return;
      _showMessage('تعذر اختيار الملف. حاول مرة أخرى.');
    }
  }

  void _clearAttachment() {
    if (!mounted) return;

    setState(() {
      _selectedImage = null;
      _selectedFile = null;
    });
  }

  Widget _buildAttachmentPreview() {
    final image = _selectedImage;
    final file = _selectedFile;

    if (image == null && file == null) {
      return const SizedBox.shrink();
    }

    final isImage = image != null;
    final name = image?.name ?? file?.name ?? 'مرفق';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5FE7FF).withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isImage
                ? FutureBuilder<Uint8List>(
                    future: image.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        );
                      }

                      return Container(
                        width: 54,
                        height: 54,
                        color: Colors.white.withValues(alpha: 0.06),
                        child: const Icon(
                          Icons.image_outlined,
                          color: Color(0xFF5FE7FF),
                        ),
                      );
                    },
                  )
                : Container(
                    width: 54,
                    height: 54,
                    color: Colors.white.withValues(alpha: 0.06),
                    child: Icon(
                      _attachmentIconForName(name),
                      color: const Color(0xFF5FE7FF),
                    ),
                  ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                 Text(
                   isImage ? 'صورة جاهزة للإرسال' : 'جاهز للإرسال',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.48),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'إزالة المرفق',
            onPressed: _sending ? null : _clearAttachment,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }

  IconData _attachmentIconForName(String name) {
    final lower = name.toLowerCase();

    if (lower.endsWith('.pdf')) {
      return Icons.picture_as_pdf_rounded;
    }

    if (lower.endsWith('.json')) {
      return Icons.data_object_rounded;
    }

    if (lower.endsWith('.dart') ||
        lower.endsWith('.py') ||
        lower.endsWith('.js') ||
        lower.endsWith('.ts') ||
        lower.endsWith('.java') ||
        lower.endsWith('.kt') ||
        lower.endsWith('.swift')) {
      return Icons.code_rounded;
    }

    return Icons.description_outlined;
  }


  Future<void> _sendMessage({
    String? suggestedMessage,
  }) async {
    final text = suggestedMessage ?? _messageController.text.trim();
    final selectedImage = _selectedImage;
    final selectedFile = _selectedFile;
    final hasAttachment = selectedImage != null || selectedFile != null;

    if ((text.isEmpty && !hasAttachment) || _sending) return;

    _messageController.clear();

    if (mounted) {
      setState(() {
        _selectedImage = null;
        _selectedFile = null;
      });
    }

    if (_currentConversationId == null) {
      try {
        final response = await http
            .post(
              Uri.parse('$baseUrl/conversations'),
              headers: _authHeaders,
            )
            .timeout(const Duration(seconds: 60));

        if (response.statusCode == 401) {
          await _handleUnauthorized();
          return;
        }

        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (response.statusCode != 201) {
          throw Exception();
        }

        final conversation = Conversation.fromJson(
          Map<String, dynamic>.from(data['conversation']),
        );

        if (!mounted) return;

        setState(() {
          _currentConversationId = conversation.id;
          _conversations.removeWhere(
            (item) => item.id == conversation.id,
          );
          _conversations.insert(0, conversation);
        });
      } catch (_) {
        if (!mounted) return;
        _showMessage('تعذر إنشاء المحادثة. حاول مرة أخرى.');
        return;
      }
    }

    final displayText = text.isEmpty
        ? '📎 ${selectedImage?.name ?? selectedFile?.name ?? 'مرفق'}'
        : hasAttachment
            ? '$text\n📎 ${selectedImage?.name ?? selectedFile?.name ?? 'مرفق'}'
            : text;

    setState(() {
      _messages.add(
        ChatMessage(
          text: displayText,
          isUser: true,
        ),
      );
      _sending = true;
    });

    _scrollToBottom();

    try {
      http.Response response;

      if (selectedImage != null || selectedFile != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/chat'),
        );

        request.headers.addAll(_multipartHeaders);
        request.fields['message'] = text;
        request.fields['conversation_id'] =
            _currentConversationId.toString();

        if (selectedImage != null) {
          final bytes = await selectedImage.readAsBytes();

          if (bytes.isEmpty) {
            throw Exception('الصورة فارغة.');
          }

          request.files.add(
            http.MultipartFile.fromBytes(
              'attachment',
              bytes,
              filename: selectedImage.name,
            ),
          );
        } else {
          final path = selectedFile!.path;

          if (path == null || path.isEmpty) {
            throw Exception('تعذر قراءة الملف من الجهاز.');
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              'attachment',
              path,
              filename: selectedFile.name,
            ),
          );
        }

        final streamedResponse = await request
            .send()
            .timeout(const Duration(seconds: 150));

        response = await http.Response.fromStream(streamedResponse);
      } else {
        response = await http
            .post(
              Uri.parse('$baseUrl/chat'),
              headers: _authHeaders,
              body: jsonEncode({
                'message': text,
                'conversation_id': _currentConversationId,
              }),
            )
            .timeout(const Duration(seconds: 150));
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }

      if (response.statusCode == 200) {
        final reply = data['reply']?.toString() ?? 'لم يصل رد من Gideon.';
        final returnedId = int.tryParse(
          data['conversation_id']?.toString() ?? '',
        );
        final returnedTitle = data['conversation_title']?.toString();

        if (!mounted) return;

        setState(() {
          if (returnedId != null) {
            _currentConversationId = returnedId;

            final index = _conversations.indexWhere(
              (item) => item.id == returnedId,
            );

            if (index >= 0 && returnedTitle != null) {
              _conversations[index].title = returnedTitle;
            }
          }

          _messages.add(
            ChatMessage(
              text: reply,
              isUser: false,
            ),
          );
        });

        await _loadConversations();
      } else {
        final reply = data['reply']?.toString() ??
            data['error']?.toString() ??
            'حدث خطأ في السيرفر.';

        if (!mounted) return;

        setState(() {
          _messages.add(
            ChatMessage(
              text: reply,
              isUser: false,
            ),
          );
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            text: 'تعذر إرسال المرفق أو الاتصال بالسيرفر. تأكد من الإنترنت وحاول مرة أخرى.',
            isUser: false,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _startNewChat({
    bool closeDrawer = false,
  }) async {
    await _createNewConversation(
      closeDrawer: closeDrawer,
    );
  }

  Future<void> _renameConversation(
    Conversation conversation,
  ) async {
    final controller = TextEditingController(
      text: conversation.title,
    );

    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0E1A2A),
          title: const Text('تغيير اسم المحادثة'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 160,
            decoration: const InputDecoration(
              hintText: 'اسم المحادثة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (title == null || title.isEmpty) return;

    try {
      final response = await http
          .patch(
            Uri.parse(
              '$baseUrl/conversations/${conversation.id}',
            ),
            headers: _authHeaders,
            body: jsonEncode({
              'title': title,
            }),
          )
          .timeout(
            const Duration(seconds: 60),
          );

      if (response.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }

      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      final updated = Conversation.fromJson(
        Map<String, dynamic>.from(data['conversation']),
      );

      if (!mounted) return;

      setState(() {
        final index = _conversations.indexWhere(
          (item) => item.id == updated.id,
        );

        if (index >= 0) {
          _conversations[index].title = updated.title;
        }
      });
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'تعذر تغيير اسم المحادثة.',
      );
    }
  }

  Future<void> _deleteConversation(
    Conversation conversation,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0E1A2A),
          title: const Text('حذف المحادثة'),
          content: const Text(
            'هل تريد حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final response = await http
          .delete(
            Uri.parse(
              '$baseUrl/conversations/${conversation.id}',
            ),
            headers: _authHeaders,
          )
          .timeout(
            const Duration(seconds: 60),
          );

      if (response.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }

      if (response.statusCode != 200) {
        throw Exception();
      }

      if (!mounted) return;

      setState(() {
        _conversations.removeWhere(
          (item) => item.id == conversation.id,
        );

        if (_currentConversationId == conversation.id) {
          _currentConversationId = null;
          _messages.clear();
        }
      });
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'تعذر حذف المحادثة.',
      );
    }
  }

  Future<void> _openGideonWebsite() async {
    final uri = Uri.parse('https://gideonassistant.uk');

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage(
          'تعذر فتح موقع Gideon. حاول مرة أخرى.',
        );
      }
    } catch (_) {
      if (!mounted) return;
      _showMessage(
        'تعذر فتح موقع Gideon. حاول مرة أخرى.',
      );
    }
  }

  void _showAbout() {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0E1A2A),
          title: const Text('Gideon'),
          content: const Text(
            'Gideon\n\n'
            'AI Assistant developed by Daniel.\n\n'
            '© 2026 Daniel',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmLogout() async {
    Navigator.of(context).pop();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0E1A2A),
          title: const Text('تسجيل الخروج'),
          content: const Text(
            'هل تريد تسجيل الخروج من حسابك؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await widget.onLogout();
    }
  }

  String _formatConversationDate(
    DateTime? date,
  ) {
    if (date == null) return '';

    final local = date.toLocal();
    final now = DateTime.now();
    final difference = now.difference(local);

    if (difference.inMinutes < 1) {
      return 'الآن';
    }

    if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} د';
    }

    if (difference.inDays == 0) {
      return 'اليوم';
    }

    if (difference.inDays == 1) {
      return 'أمس';
    }

    if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    }

    return '${local.day}/${local.month}/${local.year}';
  }

  Widget _buildConversationTile(
    Conversation conversation,
  ) {
    final selected =
        _currentConversationId == conversation.id;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF12364A)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.chat_bubble_outline,
          color: selected
              ? const Color(0xFF5FE7FF)
              : Colors.white.withValues(alpha: 0.7),
          size: 21,
        ),
        title: Text(
          conversation.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _formatConversationDate(
            conversation.updatedAt,
          ),
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'rename') {
              _renameConversation(conversation);
            } else if (value == 'delete') {
              _deleteConversation(conversation);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'rename',
              child: Text('إعادة التسمية'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('حذف'),
            ),
          ],
        ),
        onTap: () => _loadConversation(conversation),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF091524),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                12,
                15,
              ),
              child: Row(
                children: [
                  GideonLogo(size: 52.0, radius: 15.0),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Gideon',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () => _startNewChat(closeDrawer: true),
                  icon: const Icon(
                    Icons.add_comment_outlined,
                  ),
                  label: const Text('محادثة جديدة'),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF5FE7FF),
                    foregroundColor:
                        const Color(0xFF06131D),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                tileColor: const Color(0xFF8B63FF).withValues(alpha: 0.08),
                leading: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFB39BFF),
                ),
                title: const Text(
                  'Gideon Pro',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text(
                  '\$4.99 / month • قريبًا',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProScreen(token: widget.token),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                10,
                18,
                6,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'المحادثات السابقة',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(
                        alpha: 0.75,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loadingHistory
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _conversations.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Text(
                              'لا توجد محادثات سابقة بعد.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadConversations,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 2,
                              bottom: 12,
                            ),
                            itemCount: _conversations.length,
                            itemBuilder: (context, index) {
                              return _buildConversationTile(
                                _conversations[index],
                              );
                            },
                          ),
                        ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.account_circle_outlined,
              ),
              title: const Text('الحساب'),
              subtitle: Text(
                widget.email,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AccountScreen(
                      token: widget.token,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
              ),
              title: const Text('الإعدادات'),
              subtitle: const Text('الحساب والتخصيص والخصوصية'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                      token: widget.token,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text('حول Gideon'),
              onTap: _showAbout,
            ),
            ListTile(
              leading: const Icon(
                Icons.language_rounded,
              ),
              title: const Text('موقع Gideon'),
              subtitle: const Text(
                'gideonassistant.uk',
                style: TextStyle(fontSize: 11),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                await _openGideonWebsite();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('تسجيل الخروج'),
              onTap: _confirmLogout,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07111F),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            GideonLogo(size: 34.0, radius: 9.0),
            const SizedBox(width: 10),
            Expanded(
              child: _buildAppBarTitle(),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Gideon Pro',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProScreen(token: widget.token),
                ),
              );
            },
            icon: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFB39BFF),
            ),
          ),
          IconButton(
            tooltip: 'محادثة جديدة',
            onPressed: _startNewChat,
            icon: const Icon(
              Icons.edit_square,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF07111F),
              Color(0xFF0A1526),
              Color(0xFF07111F),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _buildWelcome()
                  : _buildMessages(),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    String title = 'Gideon';

    if (_currentConversationId != null) {
      for (final conversation in _conversations) {
        if (conversation.id == _currentConversationId) {
          title = conversation.title;
          break;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (_currentConversationId != null)
          Text(
            'محادثة',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.42),
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildWelcome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // GIDEON CORE
          _buildDaniCore(),

          const SizedBox(height: 28),

          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GIDEON CORE ONLINE',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2.2,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5FE7FF).withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'مرحبًا، أنا Gideon. شو بدنا نعمل اليوم؟',
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'فكّر، اصنع، واستكشف مع Gideon',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const SizedBox(height: 22),

          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Expanded(
                  child: _buildModeCard(
                    icon: Icons.psychology_alt_rounded,
                    label: 'THINK',
                    subtitle: 'حلّل وفكّر',
                    onTap: () => _sendMessage(
                      suggestedMessage: 'ساعدني في تحليل فكرة وأعطني أفضل الخيارات.',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModeCard(
                    icon: Icons.auto_awesome_rounded,
                    label: 'CREATE',
                    subtitle: 'ابنِ شيئًا',
                    onTap: () => _sendMessage(
                      suggestedMessage: 'ساعدني في إنشاء فكرة إبداعية جديدة.',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModeCard(
                    icon: Icons.explore_rounded,
                    label: 'EXPLORE',
                    subtitle: 'اكتشف أكثر',
                    onTap: () => _sendMessage(
                      suggestedMessage: 'أعطني موضوعًا مثيرًا أستكشفه اليوم.',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          if (_conversations.isNotEmpty) ...[
            _buildSectionHeader(
              'RECENT MISSIONS',
              'آخر نشاط',
            ),
            const SizedBox(height: 12),
            ..._conversations.take(3).map(_buildRecentMission),
          ] else ...[
            _buildSectionHeader(
              'QUICK START',
              'ابدأ من هنا',
            ),
            const SizedBox(height: 12),
            _buildQuickAction(
              icon: Icons.lightbulb_outline_rounded,
              title: 'فكرة مشروع جديد',
              subtitle: 'خلّي GIDEON يساعدك تبدأ',
              message: 'أعطني فكرة مشروع تقني مبتكر يمكنني تنفيذها.',
            ),
            const SizedBox(height: 10),
            _buildQuickAction(
              icon: Icons.code_rounded,
              title: 'مهمة برمجية',
              subtitle: 'ابنِ وتعلّم خطوة بخطوة',
              message: 'ساعدني في بناء مشروع برمجي خطوة بخطوة.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDaniCore() {
    return AnimatedBuilder(
      animation: _coreController,
      builder: (context, child) {
        final t = _coreController.value * math.pi * 2;
        final pulse = 1.0 + math.sin(t) * 0.025;
        final glow = 0.16 + (math.sin(t) + 1) * 0.035;

        return SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: t * 0.18,
                child: CustomPaint(
                  size: const Size(238, 238),
                  painter: _CoreOrbitPainter(
                    opacity: 0.55,
                  ),
                ),
              ),
              Transform.rotate(
                angle: -t * 0.10,
                child: Container(
                  width: 202,
                  height: 202,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF5FE7FF).withValues(alpha: 0.09),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.28, -0.35),
                      radius: 0.85,
                      colors: [
                        Color(0xFF214C68),
                        Color(0xFF10253B),
                        Color(0xFF071321),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF5FE7FF).withValues(alpha: 0.32),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5FE7FF).withValues(alpha: glow),
                        blurRadius: 48,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: const Color(0xFF8B63FF).withValues(alpha: 0.10),
                        blurRadius: 70,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: GideonLogo(
                      size: 102,
                      radius: 34,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 17,
                right: 27,
                child: _coreDot(7),
              ),
              Positioned(
                bottom: 22,
                left: 30,
                child: _coreDot(5),
              ),
              Positioned(
                top: 70,
                left: 12,
                child: _coreDot(4),
              ),
              Positioned(
                bottom: 57,
                right: 12,
                child: _coreDot(4),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _coreDot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF5FE7FF),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5FE7FF).withValues(alpha: 0.6),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
  Widget _buildModeCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 23,
              color: const Color(0xFF5FE7FF),
            ),
            const SizedBox(height: 9),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w800,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentMission(Conversation conversation) {
    return InkWell(
      onTap: () => _loadConversation(conversation),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B7CFF).withValues(alpha: 0.10),
              ),
              child: const Icon(
                Icons.radio_button_checked_rounded,
                size: 19,
                color: Color(0xFF8B7CFF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mission • ${_formatConversationDate(conversation.updatedAt)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required String message,
  }) {
    return InkWell(
      onTap: () => _sendMessage(suggestedMessage: message),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF5FE7FF),
              size: 23,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.42),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      itemCount: _messages.length + (_sending ? 1 : 0),
      itemBuilder: (context, index) {
        if (_sending && index == _messages.length) {
          return _typingIndicator();
        }

        return _messageBubble(
          _messages[index],
        );
      },
    );
  }

  Widget _messageBubble(
    ChatMessage message,
  ) {
    return Align(
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.82,
        ),
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF176B87)
              : Colors.white.withValues(
                  alpha: 0.065,
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(
              message.isUser ? 20 : 5,
            ),
            bottomRight: Radius.circular(
              message.isUser ? 5 : 20,
            ),
          ),
          border: message.isUser
              ? null
              : Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.06,
                  ),
                ),
        ),
        child: SelectableText(
          message.text,
          style: const TextStyle(
            fontSize: 15.5,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.06,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF07111F).withValues(alpha: 0.96),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
        ),
        child: Column(
          children: [
            _buildAttachmentPreview(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 48,
                  height: 50,
                  child: IconButton(
                    tooltip: 'إضافة مرفق',
                    onPressed: _sending ? null : _showAttachmentMenu,
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 6,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.055),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: FilledButton(
                    onPressed: _sending ? null : _sendMessage,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xFF5FE7FF),
                      foregroundColor: const Color(0xFF06131D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                            ),
                          )
                        : const Icon(Icons.arrow_upward_rounded),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
