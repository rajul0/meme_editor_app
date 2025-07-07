import 'package:flutter_bloc/flutter_bloc.dart';
import 'export_event.dart';
import 'export_state.dart';
import '../../domain/repositories/export_repository.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final ExportRepository repository;

  ExportBloc(this.repository) : super(ExportInitial()) {
    on<SaveImageEvent>(_onSaveImage);
    on<ShareImageEvent>(_onShareImage);
  }

  Future<void> _onSaveImage(
      SaveImageEvent event, Emitter<ExportState> emit) async {
    emit(ExportLoading());
    final result = await repository.saveImage(event.imageBytes);
    result.fold(
      (failure) => emit(ExportError(failure.message)),
      (res) => emit(ExportSuccess('Image saved to gallery')),
    );
  }

  Future<void> _onShareImage(
      ShareImageEvent event, Emitter<ExportState> emit) async {
    emit(ExportLoading());
    final result = await repository.shareImage(event.imageBytes);
    result.fold(
      (failure) => emit(ExportError(failure.message)),
      (_) => emit(ExportSuccess('Image shared successfully')),
    );
  }
}
