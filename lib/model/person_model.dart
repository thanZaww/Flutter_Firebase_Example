class PersonModel {
  String? name, address, profileUrl;
  num? age;
  int? timestamp;

  PersonModel({
    required this.name,
    required this.age,
    required this.address,
    required this.timestamp,
    this.profileUrl,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json['name'],
      age: json['age'],
      address: json['address'],
      timestamp: json['timestamp'],
      profileUrl: json['profileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'address': address,
      'timestamp': timestamp,
      'profileUrl': profileUrl,
    };
  }
}
