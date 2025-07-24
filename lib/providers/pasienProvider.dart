import 'package:flutter/material.dart';
import 'package:pasien/database/db.dart';
import 'package:pasien/models/pasien.dart';

class PatientProvider with ChangeNotifier {
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  Future<void> loadPatients() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('patients');
    _patients = List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
    notifyListeners();
  }

  Future<void> addPatient(Patient patient) async {
    final db = await DatabaseHelper.database;
    await db.insert('patients', patient.toMap());
    await loadPatients();
  }

  Future<void> updatePatient(Patient updatedPatient) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'patients',
      updatedPatient.toMap(),
      where: 'id = ?',
      whereArgs: [updatedPatient.id],
    );
    await loadPatients();
  }

  Future<void> deletePatient(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete('patients', where: 'id = ?', whereArgs: [id]);
    await loadPatients();
  }

  Future<Patient?> getPatientById(int id) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first);
    }
    return null;
  }
}