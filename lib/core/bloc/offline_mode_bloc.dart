import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

//bloc
class OfflineModeBloc extends Bloc<OfflineModeEvent, OfflineModeState> {
  final Box settingsBox = Hive.box('settings');

  OfflineModeBloc()
      : super(OfflineModeState(
          isOfflineMode:
              Hive.box('settings').get('isOfflineMode', defaultValue: false),
        )) {
    on<ToggleOfflineMode>((event, emit) {
      final newMode = !state.isOfflineMode;
      settingsBox.put('isOfflineMode', newMode);
      emit(state.copyWith(isOfflineMode: newMode));
    });
  }
}

// event
abstract class OfflineModeEvent extends Equatable {
  const OfflineModeEvent();

  @override
  List<Object?> get props => [];
}

class ToggleOfflineMode extends OfflineModeEvent {}

// state
class OfflineModeState extends Equatable {
  final bool isOfflineMode;

  const OfflineModeState({required this.isOfflineMode});

  OfflineModeState copyWith({bool? isOfflineMode}) {
    return OfflineModeState(
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }

  @override
  List<Object?> get props => [isOfflineMode];
}
