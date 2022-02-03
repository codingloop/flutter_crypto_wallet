import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:flutter/material.dart';

class AddView extends StatefulWidget {
  const AddView({Key? key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  List<String> coins = [
    "bitcoin",
    "tether",
    "etherium",
  ];
  String dropdownValue = "bitcoin";
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
            value: dropdownValue,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            items: coins.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                child: Text(value),
                value: value,
              );
            }).toList(),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Coin amount",
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: MaterialButton(
              onPressed: () async {
                // Todo
                await addCoin(dropdownValue, _amountController.text);
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}
