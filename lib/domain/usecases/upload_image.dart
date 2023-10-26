import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/entities/upload_image_params.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class UploadImageImgur {
  final Repository repository;
  UploadImageImgur(this.repository);
  Future<Either<Failure, String>> execute(UploadImage uploadImage) {
    return repository.uploadImage(uploadImage);
  }
}
