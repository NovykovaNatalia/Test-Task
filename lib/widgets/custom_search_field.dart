import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../themes/app_colors.dart';
import '../themes/images.dart';

class SearchField extends StatefulWidget {
  final Function? onCloseTap;
  final Function? onTextChanged;
  final Function? onTextSubmitted;

  const SearchField(
      {super.key, this.onCloseTap, this.onTextSubmitted, this.onTextChanged});

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late bool _isFocused;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            _isFocused ? AppColors.primary.withOpacity(0.1) : AppColors.layer_1,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _textEditingController,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: 'Search',
          hintStyle: const TextStyle(color: AppColors.hintColor),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2.0, color: AppColors.primary),
            borderRadius: BorderRadius.circular(30),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 18, right: 14),
            child: SvgPicture.asset(
              Images.searchIcon,
              height: 20,
              color: AppColors.primary,
            ),
          ),
          suffixIcon: _textEditingController.text.isEmpty
              ? null
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _textEditingController.clear();
                      widget.onCloseTap?.call();
                      _isFocused = false;
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 18),
                    child: SvgPicture.asset(
                      Images.closeIcon,
                      height: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
        ),
        onChanged: (value) {
          setState(() {
            widget.onTextChanged?.call(value);
          });
        },
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        onEditingComplete: () {
          setState(() {
            _isFocused = false;
          });
        },
        onSubmitted: (value) {
          setState(() {
            widget.onTextSubmitted?.call();
            _isFocused = false;
          });
        },
      ),
    );
  }
}
