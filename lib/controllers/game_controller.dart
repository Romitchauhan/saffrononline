class Yantra {
  final String id;
  final String no;
  final String yantraName;
  final String yantraPrice;
  final String yantraImage;

  Yantra({
    required this.id,
    required this.no,
    required this.yantraName,
    required this.yantraPrice,
    required this.yantraImage,
  });

  factory Yantra.fromJson(Map<String, dynamic> json) {
    return Yantra(
      id: json['id'],
      no: json['no'],
      yantraName: json['yantra_name'],
      yantraPrice: json['yantra_price'],
      yantraImage: json['yantra_image'],
    );
  }
}
class Draw {
  final String round;
  final String winner;
  final String image;  // Change 'Image' to 'image' (case-sensitive)

  Draw({
    required this.round,
    required this.winner,
    required this.image,  // Fix the variable name
  });
}