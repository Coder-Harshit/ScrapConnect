import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.aboutUs,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.teamLead),
            subtitle: Text(
              AppLocalizations.of(context)!.teamLeadDescription,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.developer),
            subtitle: Text(
              AppLocalizations.of(context)!.developerDescription,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            title: Text(
                // 'Designer: Anmol Verma',
                AppLocalizations.of(context)!.designer),
            subtitle: Text(
              // 'Figma Designer, Song Writer',
              AppLocalizations.of(context)!.designerDescription,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            title: Text(
                // 'Supervisor: Dr. Varun Shrivastav',
                AppLocalizations.of(context)!.supervisor),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'About Our App',
                  AppLocalizations.of(context)!.aboutOurApp,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  AppLocalizations.of(context)!.aboutOurAppDescription,
                ),
                SizedBox(height: 16.0),
                Text(
                  // 'Version 1.0.0',
                  AppLocalizations.of(context)!.version,
                ),
                SizedBox(height: 16.0),
                Text(
                  // 'Copyright © 2024 ScrapConnect',
                  AppLocalizations.of(context)!.copyright,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
