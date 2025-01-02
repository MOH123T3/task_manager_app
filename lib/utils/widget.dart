import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/app_styles.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

class CustomWidget {
//Todo Global Custom TextField for whole application
  static customTextField(TextEditingController controller, String errorText,
      GestureTapCallback onTap, bool readOnly, int maxLines) {
    return TextFormField(
      maxLines: maxLines,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onTap: onTap,
      validator: (value) => value!.isEmpty ? errorText : null,
    );
  }

//Todo Global Custom Button for whole application
  static customButton(title, onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Constant.isDark
            ? AppColors.darkButtonColor
            : AppColors.lightButtonColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      child: Text(title,
          style: Constant.isDark
              ? AppStyles.darkThemeTextStyle(15, AppColors.blackColor)
              : AppStyles.lightThemeTextStyle(15, AppColors.whiteColor)),
    );
  }
}
