import 'package:flutter/material.dart';
import 'package:responsipm/bloc/penerbit_bloc.dart';
import 'package:responsipm/model/penerbit.dart';
import 'package:responsipm/ui/penerbit_page.dart';
import 'package:responsipm/widget/success_dialog.dart';
import 'package:responsipm/widget/warning_dialog.dart';

class PenerbitForm extends StatefulWidget {
  final Penerbit? penerbit;

  PenerbitForm({Key? key, this.penerbit}) : super(key: key);

  @override
  _PenerbitFormState createState() => _PenerbitFormState();
}

class _PenerbitFormState extends State<PenerbitForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "Tambah Penerbit";
  String tombolSubmit = "SIMPAN";

  final _idTextboxController = TextEditingController();
  final _publisherNameTextboxController = TextEditingController();
  final _establishedYearTextboxController = TextEditingController();
  final _countryTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.penerbit != null) {
      setState(() {
        judul = "Ubah Penerbit";
        tombolSubmit = "UBAH";
        _idTextboxController.text = widget.penerbit!.id.toString();
        _publisherNameTextboxController.text = widget.penerbit!.publisherName!;
        _establishedYearTextboxController.text =
            widget.penerbit!.establishedYear.toString();
        _countryTextboxController.text = widget.penerbit!.country!;
      });
    } else {
      _idTextboxController.text = ''; // ID otomatis kosong saat tambah
      judul = "Tambah Penerbit";
      tombolSubmit = "Tambah";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          judul,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _idTextField(),
                        const SizedBox(height: 16.0),
                        _publisherNameTextField(),
                        const SizedBox(height: 16.0),
                        _establishedYearTextField(),
                        const SizedBox(height: 16.0),
                        _countryTextField(),
                        const SizedBox(height: 24.0),
                        _buttonSubmit(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _idTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "ID (Otomatis)",
        border: OutlineInputBorder(),
      ),
      readOnly: true, // Non-editable
      controller: _idTextboxController,
      style: const TextStyle(fontFamily: 'Courier New'),
    );
  }

  Widget _publisherNameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Publisher Name",
        border: OutlineInputBorder(),
      ),
      controller: _publisherNameTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Publisher Name harus diisi";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Courier New'),
    );
  }

  Widget _establishedYearTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Established Year",
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      controller: _establishedYearTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Established Year harus diisi";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Courier New'),
    );
  }

  Widget _countryTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Country",
        border: OutlineInputBorder(),
      ),
      controller: _countryTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Country harus diisi";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Courier New'),
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: Colors.blue,
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              tombolSubmit,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (!_isLoading) {
            if (widget.penerbit != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });

    Penerbit newPenerbit = Penerbit(
      id: null,
      publisherName: _publisherNameTextboxController.text,
      establishedYear: int.tryParse(_establishedYearTextboxController.text) ?? 0,
      country: _countryTextboxController.text,
    );

    PenerbitBloc.addPenerbit(penerbit: newPenerbit).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Anda berhasil menyimpan penerbit.",
          okClick: () {
            Navigator.of(context).pop(newPenerbit);
          },
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });
    Penerbit updatePenerbit = Penerbit(id: widget.penerbit!.id!);
    updatePenerbit.publisherName = _publisherNameTextboxController.text;
    updatePenerbit.establishedYear =
        int.tryParse(_establishedYearTextboxController.text) ?? 0;
    updatePenerbit.country = _countryTextboxController.text;

    PenerbitBloc.updatePenerbit(penerbit: updatePenerbit).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Anda berhasil mengubah penerbit.",
          okClick: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const PenerbitPage()),
            );
          },
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
