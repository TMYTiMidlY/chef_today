import 'dart:io';

import 'package:chef_today/main.dart';
import 'package:chef_today/src/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _copyAssetForDemo().then((_) {
      // 检查 mounted 防止页面被销毁后再使用 context
      if (mounted) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    });
  }

  // 检查数据库中的 User 表是否为空
  Future<void> _copyAssetForDemo() async {
    final directory = await getApplicationDocumentsDirectory();

    if (await directory.exists()) {
      await for (var entity
          in directory.list(recursive: false, followLinks: false)) {
        await entity.delete(recursive: true);
      }
    }

    if (objectbox.isEmpty()) {
      const demoAssetPath = 'assets/images/demo';

      final demoImageNames = List.generate(12, (index) => '${index + 1}.png');

      for (String demoImageName in demoImageNames) {
        final byteData =
            await rootBundle.load(path.join(demoAssetPath, demoImageName));

        final filePath = path.join(directory.path, 'demo', demoImageName);

        final file = File(filePath);
        await file.create(recursive: true);

        await file.writeAsBytes(byteData.buffer.asUint8List());
      }

      objectbox.putDemoData();

      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // 加载指示器
            SizedBox(height: 20), // 间距
            Text(
              '首次运行，正在准备演示内容...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
