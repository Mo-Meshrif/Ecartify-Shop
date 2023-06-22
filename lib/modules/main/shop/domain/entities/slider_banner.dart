import 'package:equatable/equatable.dart';

class SliderBanner extends Equatable {
  final String id, title, image, type, urlType, url;

  const SliderBanner({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.urlType,
    required this.url,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        image,
        type,
        urlType,
        url,
      ];
}
