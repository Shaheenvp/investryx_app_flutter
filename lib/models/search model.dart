// search_result.dart
class SearchResult {
  final String name;
  final String location;
  final String type;
  final String description;
  final String imageUrl;

  SearchResult({
    required this.name,
    required this.location,
    required this.type,
    required this.description,
    required this.imageUrl,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
        name: json['name'],
        location: json['location'],
        type: json['type'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        );
    }
}
