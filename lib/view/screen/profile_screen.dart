import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/profile.dart';
import 'package:nelayan_coba/model/profile_menu.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/view/screen/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences _prefs;
  late Future<Profile> _futureProfile;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
    });

    _futureProfile = FishonService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    List<ProfileMenu> profileMenuList = [
      ProfileMenu(
        id: 1,
        title: 'Detail Profil',
        iconData: Icons.person,
        onTap: () {},
      ),
      ProfileMenu(
        id: 1,
        title: 'Ubah PIN',
        iconData: Icons.lock,
        onTap: () {},
      ),
      ProfileMenu(
        id: 1,
        title: 'Keluar',
        iconData: Icons.logout,
        onTap: () {
          _prefs.remove('accessToken');

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const IntroScreen()),
                (route) => false,
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Profil'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  // child: ClipOval(
                  //   child: Image.asset(
                  //     'assets/images/cat.jpg',
                  //     width: 96,
                  //   ),
                  // ),
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/images/cat.jpg'),
                  ),
                ),
                // const Text(
                //   'Agus Budi',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //   ),
                // ),
                // const Text('+628888123456'),
                FutureBuilder<Profile>(
                  future: _futureProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text('+62${snapshot.data!.phone}'),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(profileMenuList[index].iconData),
                  title: Text(profileMenuList[index].title),
                  onTap: profileMenuList[index].onTap ?? () {},
                  // minVerticalPadding: 0,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
