import 'dart:typed_data';

abstract class ExportEvent {}

class SaveImageEvent extends ExportEvent {
  final Uint8List imageBytes;
  SaveImageEvent(this.imageBytes);
}

class ShareImageEvent extends ExportEvent {
  final Uint8List imageBytes;
  ShareImageEvent(this.imageBytes);
}
