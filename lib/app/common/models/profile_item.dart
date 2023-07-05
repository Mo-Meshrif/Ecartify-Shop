class ProfileItem {
  final String icon, title;
  final void Function() onTap;

  ProfileItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
