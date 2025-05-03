import 'package:flutter/material.dart';
import 'package:sages/constants/colors.dart';

class ScanListTile extends StatelessWidget {
  final dynamic foodItem;
  final int index;
  final VoidCallback onTap;

  const ScanListTile({
    super.key,
    required this.foodItem,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> item =
        Map<String, dynamic>.from(foodItem as Map);

    IconData icon;
    Color color;
    String stateText;
    String displayText;
    bool showQuantity = true;

    switch (foodItem['state']) {
      case 'add':
        icon = Icons.add;
        color = AppColors.green;
        stateText = '放入';
        displayText = foodItem['name'] ?? '未知食材';
        break;
      case 'remove':
        icon = Icons.remove;
        color = AppColors.gray500;
        stateText = '取出';
        displayText = foodItem['name'] ?? '未知食材';
        break;
      case 'return':
        icon = Icons.reply;
        color = AppColors.greyBlue;
        stateText = '放回';
        displayText = foodItem['name'] ?? '未知食材';
        break;
      case 'error':
        icon = Icons.error;
        color = AppColors.red;
        stateText = '⚠️非食物';
        displayText = '${foodItem['name'] ?? '未知食材'}‼️';
        showQuantity = false;
        break;
      case 'warn':
        icon = Icons.warning;
        color = Colors.yellow[700]!;
        stateText = '放入';
        displayText = '${foodItem['name'] ?? '未知食材'}？🧐';
        showQuantity = false;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
        stateText = '未知';
        displayText = foodItem['name'] ?? '未知食材';
    }

    return ListTile(
      leading: Icon(icon, color: color),
      title: Row(
        children: [
          Text(
            stateText,
            style: TextStyle(color: color, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: showQuantity
          ? Text(
              '${foodItem['quantity']} ${foodItem['unit']}',
              style: const TextStyle(color: Colors.grey),
            )
          : null,
      onTap: onTap,
    );
  }
}
