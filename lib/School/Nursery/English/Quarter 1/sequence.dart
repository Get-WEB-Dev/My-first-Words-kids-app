class SequenceItem {
  final String type;
  final int id;

  SequenceItem({required this.type, required this.id});

  factory SequenceItem.fromJson(Map<String, dynamic> json) {
    return SequenceItem(
      type: json['type'],
      id: json['id'],
    );
  }
}
