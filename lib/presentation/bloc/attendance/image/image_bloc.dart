import 'package:attendme_app/domain/usecases/upload_image.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final UploadImageImgur uploadImageImgur;

  ImageBloc({required this.uploadImageImgur}) : super(InitIMS()) {
    on<OnUploadImage>((event, emit) async {
      emit(LoadingIMS());
      final result = await uploadImageImgur.execute(event.uploadImage);
      result.fold(
        (failure) => emit(ErrorIMS(failure.message)),
        (result) => emit(SuccessIMS(result)),
      );
    });
    on<OnCleanState>((event, emit) => emit(InitIMS()));
  }
}
