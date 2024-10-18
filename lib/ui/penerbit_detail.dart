import 'package:flutter/material.dart';
import 'package:responsipm/bloc/penerbit_bloc.dart';
import 'package:responsipm/model/penerbit.dart';
import 'package:responsipm/ui/penerbit_form.dart';
import 'package:responsipm/ui/penerbit_page.dart';
import 'package:responsipm/widget/warning_dialog.dart';

class PenerbitDetail extends StatefulWidget {
  final Penerbit? penerbit;

  PenerbitDetail({Key? key, this.penerbit}) : super(key: key);

  @override
  _PenerbitDetailState createState() => _PenerbitDetailState();
}

class _PenerbitDetailState extends State<PenerbitDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penerbit'),
      ),
      body: Container(
        width: double.infinity,  // Mengisi lebar penuh
        height: double.infinity, // Mengisi tinggi penuh
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.purple[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center( // Memastikan Card berada di tengah
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailRow("ID", widget.penerbit!.id.toString()),
                    const SizedBox(height: 12.0),
                    _buildDetailRow("Publisher Name", widget.penerbit!.publisherName!),
                    const SizedBox(height: 12.0),
                    _buildDetailRow("Established Year", widget.penerbit!.establishedYear.toString()),
                    const SizedBox(height: 12.0),
                    _buildDetailRow("Country", widget.penerbit!.country!),
                    const SizedBox(height: 24.0),
                    _tombolHapusEdit(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol Edit
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PenerbitForm(
                  penerbit: widget.penerbit!,
                ),
              ),
            );
          },
        ),
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        // Tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            PenerbitBloc.deletePenerbit(id: widget.penerbit!.id!).then(
              (value) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const PenerbitPage(),
                ));
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            );
          },
        ),
        // Tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
