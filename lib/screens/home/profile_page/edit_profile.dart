import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atlas/models/user.dart';
import 'package:atlas/services/database.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
    final userIdCurrUser = atlasUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            20.0), // Add padding around the content for better aesthetics
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .start, // Align the column to the start of the main axis (vertical)
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Center the row content along the x-axis
              children: [
                FutureBuilder<String>(
                  future: DatabaseService().getProfilePicture(userIdCurrUser),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    Widget imageWidget;
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      imageWidget = const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey, // Placeholder color
                      );
                    } else {
                      imageWidget = CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(snapshot.data!),
                      );
                    }
                    return imageWidget;
                  },
                ),
                const SizedBox(width: 20), // Spacing between picture and button
                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Edit Profile Picture',
                    style: TextStyle(color: Color.fromARGB(255, 143, 197, 255)),
                  ),
                  onPressed: () => DatabaseService()
                      .pickAndUploadImage(userIdCurrUser, "profilepictures"),
                ),
              ],
            ),
            // You can add more widgets below in this Column if needed
          ],
        ),
      ),
    );
  }
}
