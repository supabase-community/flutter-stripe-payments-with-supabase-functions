import 'package:flutter/material.dart';

import 'package:stripe_example/widgets/platform_icons.dart';

class Example extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Widget? leading;
  final List<DevicePlatform> platformsSupported;

  final WidgetBuilder builder;

  Example({
    required this.title,
    required this.builder,
    this.style,
    this.leading,
    this.platformsSupported = DevicePlatform.values,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final route = MaterialPageRoute(builder: builder);
        Navigator.push(context, route);
      },
      title: Text(title, style: style),
      leading: this.leading,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        PlatformIcons(supported: platformsSupported),
        Icon(Icons.chevron_right_rounded),
      ]),
    );
  }
}
