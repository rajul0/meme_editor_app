import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_editor_app/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:meme_editor_app/features/editor/presentation/bloc/editor_event.dart';

void showAddTextDialog(BuildContext context) {
  String newText = "";
  Color backgroundColor = Colors.transparent;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (bottomSheetContext) {
      final bloc = context.read<MemeEditorBloc>();

      return BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: MediaQuery.of(bottomSheetContext).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter Text", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 12),
                TextField(
                  autofocus: true,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) => newText = value,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text("Background: "),
                    const SizedBox(width: 8),
                    _buildColorOption(Colors.white, backgroundColor, (color) {
                      backgroundColor = color;
                      (bottomSheetContext as Element).markNeedsBuild();
                    }),
                    _buildColorOption(Colors.black, backgroundColor, (color) {
                      backgroundColor = color;
                      (bottomSheetContext as Element).markNeedsBuild();
                    }),
                    _buildColorOption(Colors.red, backgroundColor, (color) {
                      backgroundColor = color;
                      (bottomSheetContext as Element).markNeedsBuild();
                    }),
                    _buildColorOption(Colors.blue, backgroundColor, (color) {
                      backgroundColor = color;
                      (bottomSheetContext as Element).markNeedsBuild();
                    }),
                    _buildColorOption(Colors.yellow, backgroundColor, (color) {
                      backgroundColor = color;
                      (bottomSheetContext as Element).markNeedsBuild();
                    }),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (newText.trim().isNotEmpty) {
                      bloc.add(AddText(newText, backgroundColor));
                    }
                    Navigator.pop(bottomSheetContext);
                  },
                  child: const Text("Add"),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildColorOption(
    Color color, Color selectedColor, Function(Color) onSelect) {
  return GestureDetector(
    onTap: () => onSelect(color),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: selectedColor == color ? Colors.white : Colors.grey,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
    ),
  );
}

void showStickerPicker(BuildContext context) {
  final stickerList = [
    'assets/stickers/sticker1.png',
    'assets/stickers/sticker2.png',
    'assets/stickers/sticker3.png',
    'assets/stickers/sticker4.png',
  ];

  showModalBottomSheet(
    context: context,
    builder: (bottomSheetContext) {
      final bloc = context.read<MemeEditorBloc>();

      return BlocProvider.value(
        value: bloc,
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemCount: stickerList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final stickerPath = stickerList[index];
            return GestureDetector(
              onTap: () {
                bloc.add(AddSticker(stickerPath));
                Navigator.pop(context);
              },
              child: Image.asset(stickerPath),
            );
          },
        ),
      );
    },
  );
}

Widget buildResizableDraggableText(
  BuildContext context,
  String text,
  double posX,
  double posY,
  double fontSize,
  int backgroundColorValue,
  void Function(double dx, double dy) onDragEnd,
  void Function(double newFontSize) onResizeEnd,
) {
  Offset position = Offset(posX, posY);
  double currentFontSize = fontSize;

  return StatefulBuilder(
    builder: (context, setState) {
      return Positioned(
        left: position.dx,
        top: position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              position += details.delta;
            });
          },
          onPanEnd: (_) {
            onDragEnd(position.dx, position.dy);
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: currentFontSize,
                    color: Color(backgroundColorValue),
                  ),
                ),
              ),
              Positioned(
                right: -10,
                bottom: -10,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      currentFontSize += details.delta.dx * 0.2;
                      if (currentFontSize < 8) currentFontSize = 8;
                      if (currentFontSize > 100) currentFontSize = 100;
                    });
                  },
                  onPanEnd: (_) {
                    onResizeEnd(currentFontSize);
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Icon(Icons.open_in_full,
                        size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildResizableDraggableItem(
    BuildContext context,
    Widget child,
    double posX,
    double posY,
    double width,
    double height,
    void Function(double, double) onDragEnd,
    void Function(double, double) onResizeEnd) {
  Offset position = Offset(posX, posY);
  double currentWidth = width;
  double currentHeight = height;

  return StatefulBuilder(
    builder: (context, setState) {
      return Positioned(
        left: position.dx,
        top: position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              position += details.delta;
            });
          },
          onPanEnd: (_) {
            onDragEnd(position.dx, position.dy);
          },
          child: Stack(
            children: [
              Container(
                width: currentWidth,
                height: currentHeight,
                alignment: Alignment.center,
                child: child,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      currentWidth =
                          (currentWidth + details.delta.dx).clamp(30, 500);
                      currentHeight =
                          (currentHeight + details.delta.dy).clamp(30, 500);
                    });
                  },
                  onPanEnd: (_) {
                    onResizeEnd(currentWidth, currentHeight);
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Icon(Icons.open_in_full,
                        size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
