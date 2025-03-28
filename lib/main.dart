import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
  await Supabase.initialize(
    url: 'https://lixmqqrrbeooilttgkbl.supabase.co', // Замените на ваш Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxpeG1xcXJyYmVvb2lsdHRna2JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI2NzExNjYsImV4cCI6MjA1ODI0NzE2Nn0.T8oqCyR5SRuf5G9gFxTStMgrgBvf8r-xy3VJbz-c6H0', // Замените на ваш Anon Key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<Map<String, dynamic>> _data = [];

  void _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вход выполнен успешно!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка входа: $e')),
      );
    }
  }

  void _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Регистрация успешна! Проверьте почту.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка регистрации: $e')),
      );
    }
  }

  void _addData(String name) async {
    try {
      await _supabase.from('your_table_name').insert({'name': name});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Данные добавлены!')),
      );
      _fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка добавления данных: $e')),
      );
    }
  }

  void _fetchData() async {
    try {
      final response = await _supabase.from('your_table_name').select();
      setState(() {
        _data = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки данных: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supabase Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _signIn,
                  child: Text('Войти'),
                ),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text('Зарегистрироваться'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addData('New Item'),
              child: Text('Добавить данные'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final item = _data[index];
                  return ListTile(
                    title: Text(item['name']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}