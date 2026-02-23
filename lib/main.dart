import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize home_widget
  await HomeWidget.setAppGroupId('group.com.jboycode.homeWidgetApp');
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Widget App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  final TextEditingController _messageController = TextEditingController(text: 'Widget');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final counter = await HomeWidget.getWidgetData<int>('counter', defaultValue: 0);
    final message = await HomeWidget.getWidgetData<String>('message', defaultValue: 'Widget');
    
    setState(() {
      _counter = counter ?? 0;
      _messageController.text = message ?? 'Widget';
    });
  }

  Future<void> _updateWidget() async {
    try {
      await HomeWidget.saveWidgetData<int>('counter', _counter);
      await HomeWidget.saveWidgetData<String>('message', _messageController.text);
      await HomeWidget.updateWidget(
        iOSName: 'MyWidget',
        androidName: 'MyAppWidget',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ウィジェットを更新しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e')),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホームウィジェット設定'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'カウンター',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() => _counter--);
                    },
                    tooltip: '減らす',
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() => _counter++);
                    },
                    tooltip: '増やす',
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'メッセージ',
                  hintText: 'ウィジェットに表示するメッセージを入力',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _updateWidget,
                icon: const Icon(Icons.update),
                label: const Text('ウィジェットを更新'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
