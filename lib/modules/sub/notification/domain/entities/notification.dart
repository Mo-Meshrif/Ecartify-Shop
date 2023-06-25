import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String id, pageType, url, status, dateAdded, title, content;

  const Notification({
    required this.id,
    required this.pageType,
    required this.url,
    required this.status,
    required this.dateAdded,
    required this.title,
    required this.content,
  });

  Notification copyWith({String? status}) => Notification(
        id: id,
        pageType: pageType,
        url: url,
        status: status ?? this.status,
        dateAdded: dateAdded,
        title: title,
        content: content,
      );
      
  @override
  List<Object?> get props => [
        id,
        pageType,
        url,
        status,
        dateAdded,
        title,
        content,
      ];
}
