// mengonversi objek ke dalam bentuk map (toMap) dan mengonversi dari map ke objek (fromMap)

class Shoe {
  final int id;
  final String name;
  final String price;
  final String image;

  Shoe({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
    };
  }

  factory Shoe.fromMap(Map<String, dynamic> map) {
    return Shoe(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
    );
  }
}
