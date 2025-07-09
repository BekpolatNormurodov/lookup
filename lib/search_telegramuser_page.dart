import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchTelegramUserPage extends StatefulWidget {
  const SearchTelegramUserPage({super.key});

  @override
  State<SearchTelegramUserPage> createState() => _SearchTelegramUserPageState();
}

class _SearchTelegramUserPageState extends State<SearchTelegramUserPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _results = [];
  bool _loading = false;

  Future<void> _searchUser() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _results.clear();
    });

    final url = Uri.parse('https://e1c2ac545495.ngrok-free.app/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _results = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xatolik: ${response.statusCode}')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ulanishda xatolik yuz berdi')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildUserCard(dynamic user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.shade100, Colors.cyan.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("👤 Ism: ${user['first_name']} ${user['last_name'] ?? ''}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text("📞 Telefon: ${user['phone']}"),
          Text("🆔 Telegram ID: ${user['telegram_id']}"),
          if (user['username'] != null)
            Text("🔗 Username: @${user['username']}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade800,
        title: const Text(
          'Telegram User',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Telegram ID',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.cyan, size: 26),
                    onPressed: (){
                      _searchUser;
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loading)
              const CircularProgressIndicator()
            else if (_results.isEmpty)
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '🔍 Foydalanuvchi topilmadi',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) =>
                      _buildUserCard(_results[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}