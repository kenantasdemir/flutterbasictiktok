import 'package:flutter/material.dart';
import 'package:mytiktokcloneapp/controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:mytiktokcloneapp/models/MyUser.dart';
import 'package:mytiktokcloneapp/screens/preview_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CustomSearchController searchController = Get.put(CustomSearchController());
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white54 : Colors.black54;
    final borderColor = isDark ? Colors.white24 : Colors.black12;

    return Obx(() {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          title: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[200],
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor!),
            ),
            child: TextFormField(
              controller: textEditingController,
              style: TextStyle(color: textColor, fontSize: 18),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: hintColor),
                hintText: 'Kullanıcı ara...',
                hintStyle: TextStyle(fontSize: 18, color: hintColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onFieldSubmitted: (value) {
                searchController.searchUser(value);
                textEditingController.clear();
              },

            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (textEditingController.text.isNotEmpty) {
                  searchController.searchUser(textEditingController.text);
                }
              },
              icon: Icon(Icons.search, color: textColor),
            )
          ],
        ),
        body: searchController.searchedUsers.isEmpty
            ? Center(
                child: Text(
                  'Kullanıcı ara!',
                  style: TextStyle(
                    fontSize: 25,
                    color: hintColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.searchedUsers.length,
                itemBuilder: (context, index) {
                  MyUser user = searchController.searchedUsers[index];
                  return Card(
                    color: cardColor,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePhotoUrl),
                        radius: 28,
                        backgroundColor: Colors.grey[700],
                      ),
                      title: Text(
                        user.name ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PreviewProfileScreen(myUser: user),
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}