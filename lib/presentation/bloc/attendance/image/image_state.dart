import 'package:equatable/equatable.dart';

class ImageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitIMS extends ImageState {}

class LoadingIMS extends ImageState {}

class ErrorIMS extends ImageState {
  final String message;
  ErrorIMS(this.message);
}

class SuccessIMS extends ImageState {
  final String imageLink;
  SuccessIMS(this.imageLink);
}
