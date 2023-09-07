import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _homePage(),
    );
  }
}

// ignore: camel_case_types
class _homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  return ProfileScreen();
                } else {
                  return LoginPage();
                }
              }
            }));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  TextEditingController password = TextEditingController();
  bool passwordVisible = true;
  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No user found for that email");
      }
    }
    return user;
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/gd-1.png',
                              scale: 1,
                              width: 350,
                            ),
                            SizedBox(height: 10),
                            const Text(
                              'Welcome to App Dev',
                              style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 145, 139, 139),
                              ),
                            ),
                            const Text(
                              'Login Here',
                              style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 145, 139, 139),
                              ),
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.fromLTRB(20, 100, 20, 20),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                      return 'Please valid email address';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: textController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 93, 92, 92),
                                    ),
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.start,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 93, 92, 92),
                                    ),
                                    border: OutlineInputBorder(),
                                    hintText: 'Email',
                                  ),
                                )),
                            Container(
                                margin: const EdgeInsets.all(20),
                                child: TextFormField(
                                  controller: password,
                                  obscureText: passwordVisible,
                                  maxLength: 20,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                            .hasMatch(value)) {
                                      return 'Please enter correct password';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(
                                      color: Color.fromARGB(255, 93, 92, 92),
                                    ),
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.start,
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color.fromARGB(255, 93, 92, 92),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: passwordVisible
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off),
                                      color:
                                          const Color.fromARGB(255, 93, 92, 92),
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    ),
                                    border: const OutlineInputBorder(),
                                    hintText: 'Password',
                                  ),
                                )),
                            Container(
                              height: 100,
                              width: 500,
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate())
                                    //lets test the app
                                    {
                                      User? user =
                                          await loginUsingEmailPassword(
                                              email: textController.text,
                                              password: password.text,
                                              context: context);
                                      print(user);
                                    }
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ),
                          ],
                        ))))));
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Logged In'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(
                          Icons.login,
                        ))
                  ],
                ),
                body: Center(
                    child: Container(
                        padding: const EdgeInsets.only(left: 50),
                        child: const Text(
                          'Welcome to your Profile Page',
                          style: TextStyle(fontSize: 40),
                        ))))));
  }
}
