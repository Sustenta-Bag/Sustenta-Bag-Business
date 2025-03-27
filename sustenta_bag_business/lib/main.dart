import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sustenta_bag_business/ui/screens/DashboardPage.dart';
import 'package:sustenta_bag_business/ui/screens/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Erro ao carregar o arquivo .env: $e");
  }
  runApp(MyApp());
}

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'auth.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE auth (id INTEGER PRIMARY KEY, token TEXT)",
        );
      },
    );
  }

  static Future<void> saveToken(String token) async {
    final db = await database;
    await db.insert(
      'auth',
      {'id': 1, 'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> getToken() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('auth');
    if (maps.isNotEmpty) {
      return maps.first['token'] as String?;
    }
    return null;
  }

  static Future<void> deleteToken() async {
    final db = await database;
    await db.delete('auth');
  }
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false;

  Future<void> checkAuthentication() async {
    final String? token = await DatabaseHelper.getToken();
    setState(() {
      isAuthenticated = token != null;
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empresarial',
      initialRoute: isAuthenticated ? '/dashboard' : '/login',
      onGenerateRoute: (settings) {
        //if ((settings.name == '/dashboard' || settings.name == '/agenda' || settings.name == '/produtores') && !isAuthenticated) {
          //return createRoute(const LoginPage());
       // }

        switch (settings.name) {
          case '/login':
            return createRoute(const LoginPage());
          //case '/agenda':
          //  return createRoute(const AuthenticatedLayout(selectedIndex: 1));
         // case '/produtores':
          //  return createRoute(const AuthenticatedLayout(selectedIndex: 2));
          //case '/dashboard':
          //  return createRoute(const AuthenticatedLayout(selectedIndex: 0));
          case '/dashboard':
          return createRoute(const DashboardPage());
          default:
            return createRoute(const LoginPage());
        }
      },
    );
  }
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class AuthenticatedLayout extends StatefulWidget {
  const AuthenticatedLayout({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  _AuthenticatedLayoutState createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      default:
        return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2434),
        title: const Text('SUSTENTA BAG BUSINESS', style: TextStyle(color: Colors.white, fontSize: 24.0)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await DatabaseHelper.deleteToken();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D2434),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit_sharp), label: 'algo 1'),
          BottomNavigationBarItem(icon: Icon(Icons.accessible_sharp), label: 'algo 2'),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}