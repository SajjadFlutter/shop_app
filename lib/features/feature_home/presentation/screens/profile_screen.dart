import 'package:flutter/material.dart';
import 'package:shop_app/features/feature_home/presentation/utils/profile_list_model.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final List<ProfileListModel> profileList = [
    ProfileListModel(
        iconData: Icons.person, title: 'حساب کاربری شخصی', onTap: () {}),
    ProfileListModel(
        iconData: Icons.shopping_bag_outlined,
        title: 'حساب کاربری فروشگاهی',
        onTap: () {}),
    ProfileListModel(iconData: Icons.person, title: 'سفارشات', onTap: () {}),
    ProfileListModel(iconData: Icons.person, title: 'آدرس من', onTap: () {}),
    ProfileListModel(
        iconData: Icons.support_agent, title: 'پشتیبانی', onTap: () {}),
    ProfileListModel(
        iconData: Icons.exit_to_app, title: 'خروج از حساب', onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProfileListTile(
              iconData: profileList[index].iconData,
              title: profileList[index].title,
              onTap: profileList[index].onTap,
              isLast: index == profileList.length - 1 ? true : false,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 5.0),
          itemCount: profileList.length,
        ),
      ],
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function() onTap;
  final bool isLast;

  const ProfileListTile({
    super.key,
    required this.iconData,
    required this.title,
    required this.onTap,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(iconData,
            size: 32.0, color: isLast ? Colors.red : Colors.grey.shade700),
        title: Text(
          title,
          style: TextStyle(color: isLast ? Colors.red : Colors.grey.shade700),
        ),
        trailing: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isLast ? Colors.red : Colors.grey.shade700,
        ),
      ),
    );
  }
}
