import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chef_today/main.dart';

class MyCard extends StatelessWidget {
  final int index;
  final bool isSelected; // 新增参数，用于判断是否高亮

  // 构造函数中增加 isSelected 参数，默认为 false
  const MyCard(this.index, {super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4, // 卡片阴影
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // 圆角
          side: BorderSide(
            color: isSelected ? Colors.red : Colors.transparent, // 高亮选中的卡片，红色边框
            width: 3, // 边框宽度
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 图片部分
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.file(
                  File(objectbox.getNotes()[index].imgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 文字和自动填充部分
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 获取剩余高度
                  final double remainingHeight = constraints.maxHeight;

                  // 定义文字的样式
                  const TextStyle textStyle = TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  );

                  // 计算文字的高度
                  final TextPainter textPainter = TextPainter(
                    text: TextSpan(
                      text: objectbox.getNotes()[index].text,
                      style: textStyle,
                    ),
                    textDirection: TextDirection.ltr,
                    maxLines: 3, // 设定最多三行
                  )..layout(
                      maxWidth:
                          constraints.maxWidth - 32); // 减去左右 padding (16 * 2)

                  // 获取文字高度
                  final double textHeight = textPainter.size.height;

                  // 计算动态 padding，上下 padding 相同
                  final double verticalPadding =
                      (remainingHeight - textHeight) / 2;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: verticalPadding, // 动态计算的上下 padding
                      horizontal: 16, // 固定的左右 padding
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 标题
                        Text(
                          objectbox.getNotes()[index].text,
                          style: textStyle,
                          maxLines: 3, // 限制最多三行
                          overflow: TextOverflow.ellipsis, // 溢出时显示省略号
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
