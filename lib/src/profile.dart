import 'package:flutter/material.dart';
import 'package:chef_today/main.dart';
import 'objectbox/model.dart';
import 'card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String username = "厨神 001 号"; // 假设用户名
  List<Note> notes = objectbox.getMyNotes(); // 假设从 ObjectBox 获取的 Notes 列表

  // 从 ObjectBox 中删除 Note
  void _deleteNoteFromStorage(int index) {
    final int id = notes[index].id; // 假设 Note 有唯一的 id
    objectbox.deleteNoteById(id); // 调用 ObjectBox 的删除方法
    setState(() {
      notes.removeAt(index); // 从界面列表中移除
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 文字在左
          const Padding(
            padding: EdgeInsets.all(2),
            child: Text('今天开始做厨神'),
          ),
          // 使用 Spacer 将文字和图片分隔开
          const Spacer(),
          // 图片在最右
          Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              width: kToolbarHeight - 4,
              height: kToolbarHeight - 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, // 使容器成为圆形
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/the_best_icon_from_gbb.png'), // 加载传入的图片路径
                  fit: BoxFit.cover, // 让图片填充整个圆形区域
                ),
              ),
            ),
          ),
        ],
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 头像和用户名
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // 图标头像
                  const Icon(
                    Icons.account_box_rounded, // 使用 account_circle 图标作为头像
                    size: 80, // 设置图标的大小（默认是 24）
                    color: Colors.grey, // 设置图标的颜色
                  ),
                  const SizedBox(width: 16),
                  // 用户名
                  Expanded(
                    child: Text(
                      username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[350],
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 8),
                    child: Text(
                      '我的厨艺',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.black, // 设置文字颜色为黑色，以便在灰色背景上清晰可见
                      ),
                    ),
                  ),
                  if (notes.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '空空如也...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey, // 使用灰色来表示提示文本
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(notes.length, (index) {
                      return Stack(
                        children: [
                          // 原有 MyCard 组件
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: AspectRatio(
                                aspectRatio: 16 / 15,
                                child: SizedBox(
                                    width: double.infinity,
                                    child: MyCard(index))),
                          ),
                          // 右上角的删除按钮
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.cancel_outlined,
                                size: 32,
                                color: Colors.deepOrangeAccent,
                              ),
                              onPressed: () =>
                                  _deleteNoteFromStorage(index), // 删除回调
                            ),
                          ),
                        ],
                      );
                    })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
