import 'package:lookup/library.dart';

class SearchTelegramUserPage extends StatefulWidget {
  const SearchTelegramUserPage({super.key});

  @override
  State<SearchTelegramUserPage> createState() => _SearchTelegramUserPageState();
}

class _SearchTelegramUserPageState extends State<SearchTelegramUserPage> {
  late TextEditingController controller;
  late UserDataProvider provider;

  List<UserDataModel> allData = [];
  bool isLoading = false;
  bool hasSearched = false;
  String id = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    provider = context.read<UserDataProvider>();

    provider.addListener(() {
      if (provider.state == UserDataState.success) {
        setState(() {
          allData = provider.data;
          isLoading = false;
          hasSearched = true;
        });
      } else if (provider.state == UserDataState.error) {
        setState(() {
          isLoading = false;
          hasSearched = true;
        });
      }
    });
  }

  void searchData() {
    final idText = controller.text.trim();
    if (idText.isEmpty) return;

    final id = int.tryParse(idText);
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iltimos, to`g`ri ID kiriting')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
      allData = [];
    });

    provider.getData(id);
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
                onChanged: (value) {
                  id = value;
                  setState(() {});
                  if (value.isEmpty) {
                    setState(() {
                      allData = [];
                    });
                  }
                },
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Telegram ID',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchData();
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(Icons.search, color: Colors.cyan, size: 26),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (hasSearched && allData.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    '🔍 Foydalanuvchi topilmadi',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (context, index) =>
                      _buildUserCard(allData[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _buildUserCard(UserDataModel user) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.cyan.shade100,
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
        Text(
          "👤 Ism: ${user.firstName} ${user.lastName ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text('📞 Telefon: ${user.phone}', style: const TextStyle(fontSize: 15),),
        Text('🆔 Telegram ID: ${user.telegramId}', style: const TextStyle(fontSize: 15),),
        if (user.username != null) Text('🔗 Username: @${user.username}', style: const TextStyle(fontSize: 15),),
        if (user.createdAt != null)
          Text('🕒 Saqlangan vaqt: ${user.createdAt}', style: const TextStyle(fontSize: 15),),
      ],
    ),
  );
}
