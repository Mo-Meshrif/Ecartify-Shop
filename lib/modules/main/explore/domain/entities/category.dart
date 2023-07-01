import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id, name, image;
  final bool hasSub;

  const Category({
    required this.id,
    required this.name,
    required this.image,
    required this.hasSub,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        hasSub,
      ];
}
