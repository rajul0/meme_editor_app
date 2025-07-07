import 'package:flutter/material.dart';
import 'package:meme_editor_app/features/home/presentation/widget/meme_list.dart';
import 'package:meme_editor_app/features/home/presentation/widget/offline_mode_btn.dart';
import 'package:meme_editor_app/features/home/presentation/widget/theme_btn.dart';
import '../widget/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 60.0,
          right: 15.0,
          bottom: 20.0,
          left: 15.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              children: [
                OfflineModeBtn(),
                ThemeBtn(),
              ],
            ),
            const SizedBox(
              width: 10.0,
            ),
            SearchBarMeme(
              controller: searchController,
            ),
            const SizedBox(
              height: 25.0,
            ),
            const Expanded(
              child: MemeList(),
            )
          ],
        ),
      ),
    );
  }
}
