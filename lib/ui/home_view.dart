import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api_methods.dart';
import 'package:crypto_wallet/ui/add_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double etherium = 0.0;
  double tether = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    getValue(String id, double amount) {
      if (id == "bitcoin") {
        return bitcoin * amount;
      } else if (id == "etherium") {
        return etherium * amount;
      } else {
        return tether * amount;
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('Coins')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Coin name: ${document.id}"),
                        Text(
                            "Amount Owned ${getValue(document.id, (document.data() as dynamic)['Amount']).toStringAsFixed(2)}"),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddView(),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  getValues() async {
    bitcoin = await getPrice("bitcoin");
    etherium = await getPrice("bitcoin");
    tether = await getPrice("bitcoin");
    setState(() {});
  }
}
