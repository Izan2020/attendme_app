import 'package:attendme_app/domain/entities/upload_image_params.dart';

class ImageEvent {}

class OnUploadImage extends ImageEvent {
  final UploadImage uploadImage;
  OnUploadImage(this.uploadImage);
}

class OnCleanState extends ImageEvent {}
