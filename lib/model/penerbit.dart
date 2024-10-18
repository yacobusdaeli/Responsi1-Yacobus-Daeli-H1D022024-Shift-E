class Penerbit {
  int? id;
  String? publisherName;
  int? establishedYear;
  String? country;

  Penerbit({this.id, this.publisherName, this.establishedYear, this.country});

  factory Penerbit.fromJson(Map<String, dynamic> obj) {
    return Penerbit(
      id: obj['id'],
      publisherName: obj['publisher_name'],
      establishedYear: obj['established_year'],
      country: obj['country'],
    );
  }
}
