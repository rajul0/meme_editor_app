import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_editor_app/core/bloc/offline_mode_bloc.dart';

class OfflineModeBtn extends StatelessWidget {
  const OfflineModeBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineModeBloc, OfflineModeState>(
      builder: (context, state) {
        return Row(
          children: [
            const Text("Offline Mode"),
            const SizedBox(width: 8),
            Switch(
              value: state.isOfflineMode,
              onChanged: (_) {
                context.read<OfflineModeBloc>().add(ToggleOfflineMode());
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        );
      },
    );
  }
}
