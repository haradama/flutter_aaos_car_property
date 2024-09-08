import 'package:flutter/material.dart';
import 'package:flutter_aaos_car_property/flutter_aaos_car_property.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Control',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Car Night Mode & Cabin Lights Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isNightMode = false; // ナイトモードの状態を保存
  int _cabinLightState = 0; // キャビンライトの状態を保存
  bool _initialized = false; // 初期化状態
  final FlutterAaosCarProperty _carProperty =
      FlutterAaosCarProperty(); // CarPropertyインスタンス

  @override
  void initState() {
    super.initState();
    _initializeCarManager(); // ウィジェットがロードされた時にCarPropertyManagerを初期化
  }

  // CarPropertyManagerを初期化し、ナイトモードの初期状態を取得
  Future<void> _initializeCarManager() async {
    await _carProperty.initializeCarManager();
    setState(() {
      _initialized = true; // 初期化完了後にUIを更新
    });
    _getNightModeStatus(); // 初期化後にナイトモード状態を取得
  }

  // ナイトモード状態を車両から取得
  Future<void> _getNightModeStatus() async {
    final bool? value =
        await _carProperty.getCarProperty(0x11200407, 0) as bool?;
    if (value != null) {
      setState(() {
        debugPrint(value.toString()); // デバッグ用にナイトモードの状態を出力
        _isNightMode = value; // UIに取得したナイトモードの値を反映
      });
    }
  }

  // ユーザーが選択したキャビンライト状態を設定
  Future<void> _setCabinLight(int state) async {
    await _carProperty.setCarProperty(0x11400f02, 0, state);
    setState(() {
      _cabinLightState = state; // UIに新しいキャビンライトの状態を反映
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isNightMode
          ? ThemeData.dark() // ナイトモードがONならダークテーマ
          : ThemeData.light(), // ナイトモードがOFFならライトテーマ
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: _initialized
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Car Night Mode Status:'),
                    Text(
                      _isNightMode
                          ? "Night Mode ON"
                          : "Night Mode OFF", // ナイトモードの状態を表示
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _getNightModeStatus, // クリックでナイトモードの状態を更新
                      child: const Text('Get Night Mode Status'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Cabin Lights:'),
                    DropdownButton<int>(
                      value: _cabinLightState, // 現在のキャビンライトの状態
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text('OFF'),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text('ON'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Daytime Running'),
                        ),
                        DropdownMenuItem(
                          value: 0x100,
                          child: Text('Automatic'),
                        ),
                      ],
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          _setCabinLight(newValue); // 新しいキャビンライトの状態を設定
                        }
                      },
                    ),
                    Text(
                      _cabinLightState == 0
                          ? "Cabin Light OFF"
                          : _cabinLightState == 1
                              ? "Cabin Light ON"
                              : _cabinLightState == 2
                                  ? "Daytime Running"
                                  : "Automatic", // 現在のキャビンライトの状態を表示
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                )
              : const CircularProgressIndicator(), // 初期化中はロードインジケータを表示
        ),
      ),
    );
  }
}
