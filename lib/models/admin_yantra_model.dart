class AdminYantra {
  final String id;
  final String yantraName;
  final String yantraImage;
  final String yantraPrice;
  final String date;

  AdminYantra({
    required this.id,
    required this.yantraName,
    required this.yantraImage,
    required this.yantraPrice,
    required this.date,
  });

  factory AdminYantra.fromJson(Map<String, dynamic> json) {
    return AdminYantra(
      id: json['id'],
      yantraName: json['yantra_name'],
      yantraImage: json['yantra_image'],
      yantraPrice: json['yantra_price'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yantra_name': yantraName,
      'yantra_image': yantraImage,
      'yantra_price': yantraPrice,
      'date': date,
    };
  }
}
