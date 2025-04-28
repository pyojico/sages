import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/form_container_widget.dart';

Future<void> showEditDialog(
  BuildContext context,
  dynamic foodItem,
  int index,
  DatabaseReference databaseRef,
) async {
  final Map<String, dynamic> item = Map<String, dynamic>.from(foodItem as Map);

  final TextEditingController nameController =
      TextEditingController(text: item['name']?.toString() ?? '');
  final TextEditingController quantityController =
      TextEditingController(text: item['quantity']?.toString() ?? '1');
  final TextEditingController unitController =
      TextEditingController(text: item['unit']?.toString() ?? '');

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('編輯食材 - ${item['name'] ?? '未知食材'}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('掃描時間: ${item['scanTime'] ?? '未知時間'}'),
              const SizedBox(height: 16),
              FormContainerWidget(
                controller: nameController,
                hintText: '食材名稱',
              ),
              const SizedBox(height: 8),
              FormContainerWidget(
                controller: quantityController,
                hintText: '數量',
                inputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 8),
              FormContainerWidget(
                controller: unitController,
                hintText: '單位',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final String currentState = item['state']?.toString() ?? '';
              final String newState =
                  (currentState == 'warn' || currentState == 'error')
                      ? 'add'
                      : currentState;

              final updatedItem = {
                'name': nameController.text,
                'quantity': double.tryParse(quantityController.text) ?? 1.0,
                'unit': unitController.text,
                'foodType': item['foodType']?.toString() ?? '',
                'state': newState,
                'scanTime': item['scanTime']?.toString() ?? '',
              };

              final snapshot = await databaseRef.get();
              List<dynamic> ingredientsList = [];
              if (snapshot.exists) {
                final data = snapshot.value;
                if (data is List) {
                  ingredientsList = List.from(data);
                } else if (data is Map) {
                  if (data['ingredients'] != null &&
                      data['ingredients'] is Iterable) {
                    ingredientsList = List.from(data['ingredients']);
                  }
                }
              }

              if (index >= 0 && index < ingredientsList.length) {
                ingredientsList[index] = updatedItem;
              } else {
                print("Index out of range: $index");
                return;
              }

              await databaseRef.set(ingredientsList);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
          TextButton(
            onPressed: () async {
              final snapshot = await databaseRef.get();
              List<dynamic> ingredientsList = [];
              if (snapshot.exists) {
                final data = snapshot.value;
                if (data is List) {
                  ingredientsList = List.from(data);
                } else if (data is Map) {
                  if (data['ingredients'] != null &&
                      data['ingredients'] is Iterable) {
                    ingredientsList = List.from(data['ingredients']);
                  }
                }
              }

              if (index >= 0 && index < ingredientsList.length) {
                ingredientsList.removeAt(index);
              } else {
                print("Index out of range: $index");
                return;
              }

              await databaseRef.set(ingredientsList);
              Navigator.pop(context);
            },
            child: const Text('刪除', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

Future<void> showErrorDialog(
  BuildContext context,
  dynamic foodItem,
) async {
  final Map<String, dynamic> item = Map<String, dynamic>.from(foodItem as Map);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('錯誤 - ${item['name'] ?? '未知食材'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('掃描時間: ${item['scanTime'] ?? '未知時間'}'),
            const SizedBox(height: 8),
            const Text('無法識別此食材，請重新掃描。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('確定'),
          ),
        ],
      );
    },
  );
}

Future<void> showAddDialog(
  BuildContext context, {
  required Function(Map<String, dynamic>) onSave,
}) async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '1');
  final TextEditingController unitController = TextEditingController(text: '個');
  final TextEditingController foodTypeController =
      TextEditingController(text: '其他');

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('新增食材'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              FormContainerWidget(
                controller: nameController,
                hintText: '食材名稱',
              ),
              const SizedBox(height: 8),
              FormContainerWidget(
                controller: quantityController,
                hintText: '數量',
                inputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 8),
              FormContainerWidget(
                controller: unitController,
                hintText: '單位',
              ),
              const SizedBox(height: 8),
              FormContainerWidget(
                controller: foodTypeController,
                hintText: '食材類型',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final newItem = {
                'name': nameController.text,
                'quantity': double.tryParse(quantityController.text) ?? 1.0,
                'unit': unitController.text,
                'foodType': foodTypeController.text,
                'scanTime': DateTime.now().toString(),
              };
              onSave(newItem);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      );
    },
  );
}
