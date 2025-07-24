class Patient {
  int? id;
  String name;
  int age;
  String gender;
  String diagnosis;
  String admissionDate;
  String photoUrl;

  Patient({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.diagnosis,
    required this.admissionDate,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'diagnosis': diagnosis,
      'admissionDate': admissionDate,
      'photoUrl': photoUrl,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      diagnosis: map['diagnosis'],
      admissionDate: map['admissionDate'],
      photoUrl: map['photoUrl'],
    );
  }

  Patient copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    String? diagnosis,
    String? admissionDate,
    String? photoUrl,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      diagnosis: diagnosis ?? this.diagnosis,
      admissionDate: admissionDate ?? this.admissionDate,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}