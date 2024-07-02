import 'package:chat_app/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              AppLocalizations.of(context)!.settings,
              style: appBarStyle,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 20.w),
            child: Column(
              children: [
                Align(
                    alignment: (state.localCode == "ar")
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Text(AppLocalizations.of(context)!.language, style: chatTitleStyle)),
                Center(
                  child: DropdownMenu<String>(
                      initialSelection: state.localCode ?? "en",
                      width: MediaQuery.sizeOf(context).width * .9,
                      onSelected: (value) {
                        AppCubit.get(context)
                            .changeLocal(value ?? state.localCode ?? "en");
                      },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                            value: "en",
                            label: AppLocalizations.of(context)!.english),
                        DropdownMenuEntry(
                            value: "ar",
                            label: AppLocalizations.of(context)!.arabic),
                      ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
