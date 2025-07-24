import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pasien/providers/pasienProvider.dart';
import 'package:pasien/screens/tambahPasien.dart';
import 'package:pasien/screens/detailPasien.dart';
import 'package:pasien/models/pasien.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false).loadPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Pasien RSU',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: patientProvider.patients.isEmpty
          ? Center(
              child: Text(
                'Tidak ada data pasien',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            )
          : RefreshIndicator(
              color: Colors.teal,
              onRefresh: () => patientProvider.loadPatients(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: patientProvider.patients.length,
                itemBuilder: (context, index) {
                  final patient = patientProvider.patients[index];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.teal.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(patient.photoUrl),
                        ),
                      ),
                      title: Text(
                        patient.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        '${patient.age} tahun - ${patient.diagnosis}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletePatient(context, patient.id!),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientDetailScreen(patient: patient),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPatientScreen()),
          );
        },
      ),
    );
  }

  Future<void> _deletePatient(BuildContext context, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Konfirmasi',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text('Apakah Anda yakin ingin menghapus data pasien ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await Provider.of<PatientProvider>(context, listen: false).deletePatient(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data pasien berhasil dihapus'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }
}