import 'dart:io';

import 'package:chef_today/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  static const routeName = '/upload';

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  final TextEditingController _titleController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('厨艺展示'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '好厨好名',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入菜品名称',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '美厨美图',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = File(pickedImage.path);
                    });
                  }
                },
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 2,
                  dashPattern: const [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imageFile == null
                        ? const Center(
                            child: Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.grey,
                            ),
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _imageFile!,
                                  width: 240,
                                  height: 240,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _imageFile = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final String title = _titleController.text;
                  if (title.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('提示'),
                        content: const Text('请填写菜品名称'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 关闭对话框
                            },
                            child: const Text('确认'),
                          ),
                        ],
                      ),
                    );
                  } else if (_imageFile == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('提示'),
                        content: const Text('请上传图片'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 关闭对话框
                            },
                            child: const Text('确认'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // 上传逻辑
                    final directory = Directory(path.join(
                        (await getApplicationDocumentsDirectory()).path,
                        'demo'));
                    int largestNumber = -1;
                    if (await directory.exists()) {
                      await for (var entity in directory.list()) {
                        if (entity is File) {
                          // 获取文件名
                          String fileName = path.basename(entity.path);

                          // 提取文件名中的数字部分
                          final RegExp regex = RegExp(r'\d+'); // 匹配文件名中的数字
                          final match = regex.firstMatch(fileName);

                          if (match != null) {
                            // 将提取到的数字转换为整数
                            int number = int.parse(match.group(0)!);

                            // 比较当前提取到的数字与最大值
                            if (number > largestNumber) {
                              largestNumber = number;
                            }
                          }
                        }
                      }
                    }
                    String imgPath =
                        path.join(directory.path, '${largestNumber + 1}.png');
                    await _imageFile!.copy(imgPath);
                    objectbox.addNote(title, imgPath);
                    showModalBottomSheet(
                      context: context,
                      isDismissible: false, // 防止用户点击外部关闭
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 成功的图标
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 60,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '菜品 "$title" 上传成功！',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 关闭 BottomSheet
                                  Navigator.pop(context); // 返回上一个页面
                                },
                                child: const Text('确认'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: const Icon(
                  Icons.cloud_upload,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
