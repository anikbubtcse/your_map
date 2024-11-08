class AddressModel {
  AddressModel({required this.place});

  final Place place;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
      place: json['place'] == null
          ? Place.fromJson({})
          : Place.fromJson(json['place']));
}

class Place {
  Place({required this.address});

  final String address;

  factory Place.fromJson(Map<String, dynamic> json) =>
      Place(address: json['address'] ?? '');
}
