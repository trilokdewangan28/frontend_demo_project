import 'package:demo_project/ImagePickerPage.dart';
import 'package:demo_project/config/StaticMethod.dart';
import 'package:demo_project/config/apis.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
class ProfilePage extends StatefulWidget {
  String token;
  ProfilePage({super.key, required this.token});
  

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  bool isLoading = false;
  bool mounted = false;

  _firstLoad() async {
    print('uer profile called');
    mounted = true;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var url = Uri.parse(userProfile);
    final res = await StaticMethod.userProfileInitial(widget.token, url);
    if (res['success'] == true) {
      if (res['result'] != null) {
        userData = res['result'][0];
        print(userData);
        setState(() {
          isLoading = false;
        });
      } else {
        userData = {};
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print(res);
      StaticMethod.showDialogBar('error fetching product', Colors.red);
    }
  }

  @override
  void initState() {
    _firstLoad();
    super.initState();
  }
  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile page')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : userData != {}
              ? Center(
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagePickerPage(userDetails: userData, forWhich: 'image', imageFile: userData['image'], token: widget.token)));
                },
                child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white70,
                    child:  userData['image']
                        .isNotEmpty
                        ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl:
                          '${accessProfilePic}/${userData['image']}',
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          // Other CachedNetworkImage properties
                        )
                    )
                        :const Icon(Icons.person,
                        size: 70, color: Colors.black)
                ),
              ),
              Text(userData['uname']),
              Text(userData['email']),
            ],
          ),
        )
      )
              : Container(
                  child: Text('no data'),
                ),
    );
  }
}
