import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_event.dart';

class SearchBarMeme extends StatefulWidget {
  final TextEditingController controller;

  final String hintText;

  const SearchBarMeme({
    super.key,
    required this.controller,
    this.hintText = 'Search memes...',
  });

  @override
  State<SearchBarMeme> createState() => _SearchBarMemeState();
}

class _SearchBarMemeState extends State<SearchBarMeme> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        context.read<HomeBloc>().add(SearchMemes(value));
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.controller.clear();
                  context.read<HomeBloc>().add(SearchMemes(''));
                },
              )
            : null,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
