import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_editor_app/features/export/presentation/pages/export_page.dart';
import '../bloc/editor_bloc.dart';
import '../bloc/editor_event.dart';
import '../bloc/editor_state.dart';
import 'meme_editor_helpers.dart';

class MemeEditorPage extends StatelessWidget {
  final String imageUrl;
  final double editorWidth;
  final double editorHeight;

  const MemeEditorPage({
    super.key,
    required this.imageUrl,
    required this.editorWidth,
    required this.editorHeight,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey _globalKey = GlobalKey();
    return BlocListener<MemeEditorBloc, MemeEditorState>(
      listenWhen: (prev, curr) =>
          prev.exportedImage != curr.exportedImage &&
          curr.exportedImage != null,
      listener: (context, state) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExportPage(imageBytes: state.exportedImage!),
          ),
        );
        context.read<MemeEditorBloc>().add(ResetExportedImage());
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<MemeEditorBloc>().add(ClearMetadata(imageUrl));
              },
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () {
                context.read<MemeEditorBloc>().add(UndoEdit());
              },
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: () {
                context.read<MemeEditorBloc>().add(RedoEdit());
              },
            ),
            IconButton(
              icon: const Icon(Icons.text_format),
              onPressed: () => showAddTextDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.emoji_emotions),
              onPressed: () => showStickerPicker(context),
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                context.read<MemeEditorBloc>().add(
                      SaveAndExport(imageUrl, _globalKey),
                    );
              },
            ),
          ],
        ),
        body: Center(
          child: Stack(
            children: [
              // Layer untuk Export (RepaintBoundary)
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  width: editorWidth,
                  height: editorHeight,
                  color: Colors.black12,
                  child: BlocBuilder<MemeEditorBloc, MemeEditorState>(
                    builder: (context, state) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          ),

                          // Text murni untuk hasil export
                          for (int i = 0; i < state.texts.length; i++)
                            Positioned(
                              left: state.texts[i].posX,
                              top: state.texts[i].posY,
                              child: Text(
                                state.texts[i].text,
                                style: TextStyle(
                                  fontSize: state.texts[i].fontSize,
                                  color: Color(
                                      state.texts[i].backgroundColorValue),
                                ),
                              ),
                            ),

                          // Sticker murni untuk hasil export
                          for (int i = 0; i < state.stickers.length; i++)
                            Positioned(
                              left: state.stickers[i].posX,
                              top: state.stickers[i].posY,
                              child: Image.asset(
                                state.stickers[i].assetPath,
                                width: state.stickers[i].width,
                                height: state.stickers[i].height,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Layer Interaktif (tidak ikut di-export)
              BlocBuilder<MemeEditorBloc, MemeEditorState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.isExporting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: editorWidth,
                      height: editorHeight,
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          for (int i = 0; i < state.texts.length; i++)
                            buildResizableDraggableText(
                              context,
                              state.texts[i].text,
                              state.texts[i].posX - 9,
                              state.texts[i].posY - 9,
                              state.texts[i].fontSize,
                              state.texts[i].backgroundColorValue,
                              (dx, dy) => context
                                  .read<MemeEditorBloc>()
                                  .add(UpdateTextPosition(i, dx, dy)),
                              (newFontSize) => context
                                  .read<MemeEditorBloc>()
                                  .add(UpdateTextSize(i, newFontSize)),
                            ),
                          for (int i = 0; i < state.stickers.length; i++)
                            buildResizableDraggableItem(
                              context,
                              Image.asset(
                                state.stickers[i].assetPath,
                                width: state.stickers[i].width,
                                height: state.stickers[i].height,
                              ),
                              state.stickers[i].posX,
                              state.stickers[i].posY,
                              state.stickers[i].width,
                              state.stickers[i].height,
                              (dx, dy) => context
                                  .read<MemeEditorBloc>()
                                  .add(UpdateStickerPosition(i, dx, dy)),
                              (newWidth, newHeight) => context
                                  .read<MemeEditorBloc>()
                                  .add(UpdateStickerSize(
                                      i, newWidth, newHeight)),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
