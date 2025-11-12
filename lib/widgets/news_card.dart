import 'package:flutter/material.dart';
import 'package:football_news/screens/newslist_form.dart';
import 'package:football_news/screens/news_entry_list.dart';
import 'package:football_news/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final IconData icon;

  const ItemCard({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil instance CookieRequest dari Provider
    final request = context.watch<CookieRequest>();

    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          // Tampilkan snackbar info tombol ditekan
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol $name!")),
            );

          // ✅ 1. Arahkan ke form tambah berita
          if (name == "Add News") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsFormPage()),
            );
          }

          // ✅ 2. Arahkan ke daftar berita (news list)
          else if (name == "See Football News") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsEntryListPage()),
            );
          }

          // ✅ 3. Logout dari aplikasi
          else if (name == "Logout") {
            try {
              // Ganti URL sesuai environment kamu
              final response = await request.logout(
                "http://127.0.0.1:8000/auth/logout/",
              );

              String message = response["message"] ?? "Logout response unknown.";

              if (context.mounted) {
                if (response['status'] == true) {
                  String uname = response["username"] ?? "";
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$message See you again, $uname."),
                    ),
                  );

                  // Redirect ke halaman login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Logout failed: $e")),
              );
            }
          }
        },

        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30.0),
              const SizedBox(height: 4),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
