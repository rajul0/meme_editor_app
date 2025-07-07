import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meme_editor_app/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:meme_editor_app/features/editor/presentation/bloc/editor_event.dart';
import 'package:meme_editor_app/features/editor/presentation/pages/editor_page.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_event.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_state.dart';
import 'package:shimmer/shimmer.dart';

class MemeList extends StatelessWidget {
  const MemeList({super.key});

  void _handleScroll(
      BuildContext context, HomeLoaded state, ScrollNotification notification) {
    if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200 &&
        !state.isLoadingMore &&
        !state.hasReachedEnd) {
      context.read<HomeBloc>().add(LoadMoreMemes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeLoaded) {
          final memes = state.filteredMemes;

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _handleScroll(context, state, notification);
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshMemes());
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: memes.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= memes.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final meme = memes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (routeContext) => BlocProvider(
                            create: (_) => MemeEditorBloc()
                              ..add(LoadMetadata(meme.imageUrl)),
                            child: MemeEditorPage(
                              imageUrl: meme.imageUrl,
                              editorWidth: meme.width.toDouble(),
                              editorHeight: meme.height.toDouble(),
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: meme.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(color: Colors.grey.shade300),
                        ),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        if (state is HomeError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
