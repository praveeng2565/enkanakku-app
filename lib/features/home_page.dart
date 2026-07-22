import 'package:enkanakku_app/features/login/login_page.dart';
import 'package:enkanakku_app/services/login_auth.dart';
import 'package:enkanakku_app/utils/app_constants.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("drawing Home Page");
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: <Widget>[LogoutButton()],
      ),
      // body: StreamProvider<List<Item>>.value(
      //   // when this stream changes, the children will get
      //   // updated appropriately
      //   stream: DataService().getItemsSnapshot(),
      //   child: ItemsList(),
      // ),
      body: Center(child: Text("Welcome to Enkanakku App")),
      // drawer: Drawer(
      //   child: FutureBuilder<FirebaseUser>(
      //     future: AuthService().getUser,
      //     builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         Provider.of<MenuStateInfo>(context).setCurrentUser(snapshot.data);
      //         return MenuDrawer();
      //       } else {
      //         return CircularProgressIndicator();
      //       }
      //     },
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddItemPage(),
      //         settings: RouteSettings(name: "AddItemPage"),
      //         fullscreenDialog: true,
      //       ),
      //     );
      //   },
      //   tooltip: 'Add Item',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(Icons.exit_to_app),
      onPressed: () async {
        await AuthService().logout();

        // Navigator.pushReplacementNamed(context, "/");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: "LoginPage"),
            builder: (BuildContext context) => LoginPage(),
          ),
        );
      },
    );
  }
}
