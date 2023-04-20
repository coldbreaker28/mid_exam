import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'chipBar.dart';
import 'history_card.dart';

class ListPengecekan extends StatefulWidget {
  const ListPengecekan({Key? key}) : super(key: key);

  @override
  State<ListPengecekan> createState() => _ListPengecekanState();
}

class _ListPengecekanState extends State<ListPengecekan> {
  var idSelected = 0;
  Widget currentTab() {
    return _chipBarList[idSelected].bodyWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(225, 0, 74, 173),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            // search
            child: TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Cari...",
                prefixIcon: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular((10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          // choice chip
          SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: listChip(),
            ),
          ),
          // content
          Expanded(
            child: Center(child: currentTab()),
          ),
        ],
      ),
    );
  }

  listChip() {
    return Row(
      children: _chipBarList
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ChoiceChip(
                label: Text(item.title),
                selected: idSelected == item.id,
                labelStyle: TextStyle(
                  color: idSelected == item.id ? Colors.white : Colors.black,
                ),
                selectedColor: const Color.fromARGB(225, 0, 74, 173),
                onSelected: (_) => setState(() => idSelected = item.id),
              ),
            ),
          )
          .toList(),
    );
  }
}

class BuilderPengecekan extends StatelessWidget {
  final stream;
  const BuilderPengecekan({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return Expanded(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final documentSnapshot = snapshot.data!.docs[index];
                    final String docId = snapshot.data!.docs[index].id;
                    String kodeAset = documentSnapshot['kodeAset'];
                    String namaAset = documentSnapshot['namaAset'];
                    String cluster = documentSnapshot['cluster'];
                    String namaPetugas = documentSnapshot['petugas'];
                    String tglPengecekan = documentSnapshot['tglPengecekan'];
                    String status = documentSnapshot['statusKonfirmasi'];

                    return HistoryCard(
                      kodeAset: kodeAset,
                      namaAset: namaAset,
                      cluster: cluster,
                      namaPetugas: namaPetugas,
                      tanggal: tglPengecekan,
                      status: status,
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black,
            ),
          ),
        );
      },
    );
  }
}

// // list untuk choice chip
final _chipBarList = <ItemChipBar>[
  ItemChipBar(
    0,
    'Semua',
    BuilderPengecekan(
      stream: DatabaseService().listPengecekan(),
    ),
  ),
  ItemChipBar(
    1,
    'Belum Dikonfirmasi',
    BuilderPengecekan(
      stream: DatabaseService().listPengecekan(),
    ),
  ),
  ItemChipBar(2, 'Diterima', const Text('Tab 3')),
  ItemChipBar(3, 'Ditolak', const Text('Tab 4')),
];
