import 'package:dairyadmin/constants/helper_methods.dart';
import 'package:dairyadmin/constants/sevice_locator.dart';
import 'package:dairyadmin/constants/theme_colors.dart';
import 'package:dairyadmin/logic/view_models/settings_viewModel.dart';
import 'package:dairyadmin/views/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController priceController = TextEditingController();
  SettingsViewModel model = serviceLocator<SettingsViewModel>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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
    await model.getCurrentPrice();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
      ),
      drawer: CustomDrawer(),
      body: ChangeNotifierProvider(
        create: (context) => model,
        child: Consumer<SettingsViewModel>(
          builder: (context, model, child) {
            return SettingsList(
              sections: [
                SettingsSection(
                  tiles: [
                    SettingsTile(
                      title: 'Current Price',
                      subtitle: 'Ksh ' + model.currentPrice.toString(),
                      leading: Icon(Icons.attach_money),
                      onPressed: (context) {
                        showDialog(
                            context: context, builder: (_) => priceDialog());
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget priceDialog() {
    return AlertDialog(
      title: Text(
        'Edit Price',
        style: TextStyle(color: ThemeColors.colorPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Current Price'),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Update'),
          color: ThemeColors.colorPrimary,
          textColor: Colors.white,
          minWidth: 100,
          onPressed: () async {
            model.updateCurrentPrice(int.parse(priceController.text), context);
          },
        )
      ],
    );
  }
}
