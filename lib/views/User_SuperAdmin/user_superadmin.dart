import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Superadmin/adminLogin.dart';
import '../auth/register.dart';

class UserOrSuperadmin extends StatelessWidget {
  const UserOrSuperadmin({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Center(
            child: Container(
      width: size.width * 0.3,
      height: size.height * 0.3,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Are you a customer or Super admin?"),
          const SizedBox(
            height: 50,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLogin(),
                  ),
                );
              },
              child: const Text("Superadmin"),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationPage(),
                  ),
                );
              },
              child: const Text("Customer"),
            )
          ])
        ],
      ),
    )));
  }
}
