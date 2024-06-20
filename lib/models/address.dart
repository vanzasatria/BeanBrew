class Address {
  final String title;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String province;
  final String postalCode;
  final String note;

  Address({
    required this.title,
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.note,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      title: json['title'],
      name: json['name'],
      phone: json['phone'],
      street: json['street'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postalCode'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'name': name,
      'phone': phone,
      'street': street,
      'city': city,
      'province': province,
      'postalCode': postalCode,
      'note': note,
    };
  }

  Address copyWith({
    String? title,
    String? name,
    String? phone,
    String? street,
    String? city,
    String? province,
    String? postalCode,
    String? note,
  }) {
    return Address(
      title: title ?? this.title,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      note: note ?? this.note,
    );
  }
}
