import 'package:flutter/material.dart';

import '../../core/components/headline_with_row.dart';
import '../../core/constants/app_defaults.dart';
import 'components/all_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              /// Header
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDefaults.padding, vertical: 8.0),
                child: HeadlineRow(headline: 'settings'),
              ),

              /// Settings
              AllSettings(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
