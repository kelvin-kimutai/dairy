import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/helper_methods.dart';
import '../../services/sevice_locator.dart';
import '../../constants/theme_colors.dart';
import '../../logic/view_models/collection_viewModel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey =
      new GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  CollectionViewModel model = serviceLocator<CollectionViewModel>();

  TextEditingController farmerIdController = TextEditingController();
  TextEditingController kgsController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String selectedDate = DateFormat.yMMMEd().format(DateTime.now());

  String currentText = "";

  @override
  void initState() {
    model.scaffoldKey = scaffoldKey;
    Future.delayed(Duration.zero, () {
      loadData();
    });
    super.initState();
  }

  void loadData() async {
    HelperMethods.showLoadingDialog('Loading...', context);
    await model.getAllFarmers();
    await model.getCurrentPrice();
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null)
      setState(() {
        selectedDate = DateFormat.yMMMEd().format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          leading: Container(),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () {
                  _selectDate(context);
                }),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context, builder: (_) => collectionDialog());
                }),
          ],
          centerTitle: true,
          title: Text(selectedDate)),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Card(
              color: ThemeColors.colorPrimary,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: Text(
                      'Time',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    )),
                    Expanded(
                      child: Text(
                        'ID',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Kgs',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('collections')
                  .where('date', isEqualTo: selectedDate)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var collection = snapshot.data.docs[index];
                      return Card(
                        elevation: 3,
                        child: ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: Text(
                                  DateFormat.Hm()
                                      .format((collection['time']).toDate()),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )),
                                Expanded(
                                  child: Text(
                                    collection['id'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    collection['kgs'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: ThemeColors.colorPrimary,
                                  ),
                                  SizedBox(width: 5.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Comment',
                                          style: TextStyle(
                                            color: ThemeColors.colorPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          collection['comment'] == ""
                                              ? 'No comment'
                                              : collection['comment'],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) =>
                                              commentDialog(collection));
                                    },
                                    child: Icon(
                                      Icons.chat,
                                      color: ThemeColors.colorPrimary,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget collectionDialog() {
    return AlertDialog(
      title: Text(
        'Collect milk',
        style: TextStyle(color: ThemeColors.colorPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: kgsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Kgs collected'),
          ),
          SimpleAutoCompleteTextField(
            key: autoCompleteKey,
            keyboardType: TextInputType.phone,
            controller: farmerIdController,
            decoration: InputDecoration(hintText: 'Farmer ID'),
            textChanged: (text) => currentText = text,
            suggestions: model.farmerIds,
            clearOnSubmit: false,
            textSubmitted: (text) {},
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Submit'),
          color: ThemeColors.colorPrimary,
          textColor: Colors.white,
          minWidth: 100,
          onPressed: () async {
            await model.addCollection(kgsController.text,
                farmerIdController.text, selectedDate, context);
            setState(() {
              kgsController.text = '';
              farmerIdController.text = '';
            });
          },
        )
      ],
    );
  }

  Widget commentDialog(dynamic collection) {
    return AlertDialog(
      title: Text(
        'Add comment',
        style: TextStyle(color: ThemeColors.colorPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: commentController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(hintText: 'Comment'),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Submit'),
          color: ThemeColors.colorPrimary,
          textColor: Colors.white,
          minWidth: 100,
          onPressed: () async {
            model.requestCollectionEdit(
                collection.id, commentController.text, context);
            setState(() {
              commentController.text = '';
            });
          },
        )
      ],
    );
  }
}
