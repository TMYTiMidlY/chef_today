import 'package:flutter/material.dart';

import 'package:chef_today/main.dart';
import 'sample_feature/sample_item.dart';
import 'lottery.dart';
import 'card.dart';
import 'profile.dart';
import 'upload.dart';

/// Displays a list of SampleItems.
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/homepage';

  final List<SampleItem> items;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // 当滚动到页面底部时执行
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: const CircleBorder(), // 设置圆形对话框
              child: GestureDetector(
                onTap: () {
                  // 点击整个对话框时执行的操作
                  Navigator.of(context).pop(); // 关闭对话框
                  showLotteryModal(context);
                },
                child: Container(
                  width: 300, // 圆形对话框的宽度
                  height: 300, // 圆形对话框的高度
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // 使容器成为圆形
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/the_best_eat_icon_from_gbb.png'), // 加载传入的图片路径
                      fit: BoxFit.cover, // 让图片填充整个圆形区域
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(controller: _scrollController, slivers: [
              SliverAppBar(
                title: MyAppBar(
                  isSearching: _isSearching,
                  onSearchTap: (isSearching) {
                    setState(() {
                      _isSearching = isSearching;
                    });
                  },
                  searchController: _searchController,
                ),
                pinned: true,
              ),
              SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return MyCard(index);
                  }, childCount: objectbox.getNotesCount()),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1 / 1)),
            ]),
          ),
          const ProfilePage()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // If the user leaves and returns
          // to the app after it has been killed while running in the
          // background, the navigation stack is restored.
          Navigator.restorablePushNamed(context, UploadView.routeName);
        },
        label: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 30,
            ),
            Text('上传'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
            _pageController.jumpToPage(_pageIndex);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的')
          ]),
    );
  }
}

// class UselessListView extends StatelessWidget {
//   const UselessListView({
//     super.key,
//     required this.widget,
//   });

//   final HomePage widget;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       // Providing a restorationId allows the ListView to restore the
//       // scroll position when a user leaves and returns to the app after it
//       // has been killed while running in the background.
//       restorationId: 'sampleItemListView',
//       itemCount: widget.items.length,
//       itemBuilder: (BuildContext context, int index) {
//         final item = widget.items[index];

//         return ListTile(
//             title: Text('SampleItem ${item.id}'),
//             leading: const CircleAvatar(
//               // Display the Flutter Logo image asset.
//               foregroundImage: AssetImage('assets/images/flutter_logo.png'),
//             ),
//             onTap: () {
//               // Navigate to the details page. If the user leaves and returns to
//               // the app after it has been killed while running in the
//               // background, the navigation stack is restored.
//               Navigator.restorablePushNamed(
//                 context,
//                 SampleItemDetailsView.routeName,
//               );
//             });
//       },
//     );
//   }
// }

class MyAppBar extends StatelessWidget {
  final bool isSearching;
  final Function(bool) onSearchTap;
  final TextEditingController searchController;

  const MyAppBar({
    super.key,
    required this.isSearching,
    required this.onSearchTap,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            autofocus: isSearching, // 仅在搜索模式下自动聚焦
            readOnly: !isSearching, // 非搜索模式时文本框不可编辑
            decoration: InputDecoration(
                hintText: '今天开始做什么...', // 提示文字
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // 圆角矩形边框
                  borderSide: const BorderSide(
                    color: Colors.white, // 边框颜色
                    width: 2.0, // 边框宽度
                  ),
                ),
                filled: true,
                fillColor: Colors.white, // 搜索框背景颜色
                suffixIcon: isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          onSearchTap(false); // 退出搜索模式
                          searchController.clear(); // 清空搜索框
                        },
                      )
                    : const Icon(Icons.search), // 搜索图标
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14)),
            style: const TextStyle(
              color: Colors.black, // 输入文本的颜色
              fontSize: 16, // 文本大小
            ),
            onTap: () {
              if (!isSearching) {
                onSearchTap(true); // 进入搜索模式
              }
            },
            onSubmitted: (query) {
            },
          ),
        ),
      ),
    );
  }
}
