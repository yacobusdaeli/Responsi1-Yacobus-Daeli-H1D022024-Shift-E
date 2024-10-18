import 'package:flutter/material.dart';
import 'package:responsipm/bloc/logout_bloc.dart';
import 'package:responsipm/bloc/penerbit_bloc.dart';
import 'package:responsipm/model/penerbit.dart';
import 'package:responsipm/ui/login_page.dart';
import 'package:responsipm/ui/penerbit_detail.dart';
import 'package:responsipm/ui/penerbit_form.dart';

class PenerbitPage extends StatefulWidget {
  const PenerbitPage({Key? key}) : super(key: key);

  @override
  _PenerbitPageState createState() => _PenerbitPageState();
}

class _PenerbitPageState extends State<PenerbitPage> {
  List<Penerbit> _penerbitList = [];

  @override
  void initState() {
    super.initState();
    _loadPenerbits();
  }

  void _loadPenerbits() {
    PenerbitBloc.getPenerbits().then((value) {
      setState(() {
        _penerbitList = value;
      });
    }).catchError((error) {
      // Handle error here
      print("Error loading penerbits: $error");
    });
  }

  void _addPenerbit(Penerbit newPenerbit) {
    setState(() {
      _penerbitList.add(newPenerbit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Penerbit'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                var newPenerbit = await Navigator.push<Penerbit>(
                  context,
                  MaterialPageRoute(builder: (context) => PenerbitForm()),
                );
                if (newPenerbit != null) {
                  _addPenerbit(newPenerbit);
                }
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _penerbitList.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada penerbit ditemukan.',
                  style: TextStyle(color: Colors.white, fontFamily: 'Courier New'),
                ),
              )
            : ListPenerbit(list: _penerbitList),
      ),
    );
  }
}

class ListPenerbit extends StatelessWidget {
  final List<Penerbit>? list;
  const ListPenerbit({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list?.length ?? 0,
      itemBuilder: (context, i) {
        return ItemPenerbit(penerbit: list![i]);
      },
    );
  }
}

class ItemPenerbit extends StatelessWidget {
  final Penerbit penerbit;
  const ItemPenerbit({Key? key, required this.penerbit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PenerbitDetail(penerbit: penerbit),
          ),
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.8), // Transparansi untuk menonjolkan gradien
        child: ListTile(
          title: Text(
            penerbit.publisherName ?? 'Tanpa Nama',
            style: TextStyle(fontFamily: 'Courier New'),
          ),
          subtitle: Text(
            penerbit.country ?? 'Tanpa Negara',
            style: TextStyle(fontFamily: 'Courier New'),
          ),
        ),
      ),
    );
  }
}
