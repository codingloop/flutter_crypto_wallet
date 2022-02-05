import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api_methods.dart';
import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:crypto_wallet/ui/add_view.dart';
import 'package:crypto_wallet/ui/authentication.dart';
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
      appBar: AppBar(
        title: Text("My Coins"),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Authentication()),
                (Route<dynamic> route) => false,
              );
              //   Navigator.of(context).pushReplacement(Authentication());
              //   if (shouldNavigate) {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => HomeView()),
              //         );
            },
            icon: Icon(
              Icons.power_settings_new,
            ),
          ),
        ],
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              signOut();
              Navigator.pop(context, true);
            }),
      ),
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
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 5.0,
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 0.0,
                          ),
                          Text(
                            "${document.id}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            "${getValue(document.id, (document.data() as dynamic)['Amount']).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await removeCoin(document.id);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
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
    etherium = await getPrice("etherium");
    tether = await getPrice("tether");
    setState(() {});
  }
}
