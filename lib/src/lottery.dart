import 'package:flutter/material.dart';
import 'dart:math';

import 'card.dart';

void showLotteryModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const LotteryModal(),
      );
    },
  );
}

class LotteryModal extends StatefulWidget {
  const LotteryModal({super.key});

  @override
  State<LotteryModal> createState() => _LotteryModalState();
}

class _LotteryModalState extends State<LotteryModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  int _selectedCardIndex = -1;
  bool _isAnimating = false;

  final int _numberOfCards = 6; // 卡片数量
  final Random _random = Random(); // 随机数生成器

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // 动画持续时间
    );

    _setRandomEndValue();

    // 自动开始动画
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 设置随机end值
  void _setRandomEndValue() {
    double randomEnd = 2 * pi * (5 + _random.nextInt(6) / 6);
    _rotationAnimation = Tween<double>(begin: 0, end: randomEnd)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 动画结束时选择竖直向上的卡片
          double anglePerCard = 2 * pi / _numberOfCards;
          double finalAngle = _rotationAnimation.value % (2 * pi);
          _selectedCardIndex =
              (((-finalAngle + pi / 2) / anglePerCard).round() + 3) %
                  _numberOfCards;
          setState(() {
            _isAnimating = false;
          });
        }
      });
  }

  // 启动动画
  void _startAnimation() {
    if (!_isAnimating) {
      setState(() {
        _isAnimating = true;
        _selectedCardIndex = -1; // 重置选中的卡片
      });
      _setRandomEndValue(); // 每次启动动画时设置新的随机end值
      _controller.forward(from: 0); // 重新开始动画
    }
  }

  // 构建旋转卡片
  List<Widget> _buildRotatingCards(double radius) {
    final List<Widget> cards = List.generate(
        _numberOfCards,
        (index) => SizedBox(
            width: 280,
            height: 280,
            child: MyCard(index, isSelected: index == _selectedCardIndex)));

    return cards.asMap().entries.map((entry) {
      int index = entry.key;
      Widget card = entry.value;

      // 计算每张卡片的角度和位置
      double angle = ((index - 1 / 2) * (2 * pi / _numberOfCards)) +
          _rotationAnimation.value;
      double x = radius * cos(angle);
      double y = radius * sin(angle);

      return Transform.translate(
        offset: Offset(x, y),
        child: Transform.rotate(
          angle: angle + pi / 2, // 卡片同步旋转
          child: card,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 200; // 卡片旋转的半径

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // 中心的自定义图片
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 使容器成为圆形
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/the_best_eat_icon_from_gbb.png'), // 加载传入的图片路径
                    fit: BoxFit.cover, // 让图片填充整个圆形区域
                  ),
                ),
              ),
              // 旋转的卡片
              ..._buildRotatingCards(radius),
            ],
          ),
        ],
      ),
    );
  }
}
