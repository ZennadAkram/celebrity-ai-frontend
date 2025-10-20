import 'dart:io';
import 'dart:ui';

import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter_riverpod/legacy.dart';

final avatarSelectProvider=StateProvider<int>((ref)=>-1);
final avatarBgSelectProvider=StateProvider<int>((ref)=>-1);
final imageSelectorProvider=StateProvider<File?>((ref)=>null);
final colorSelectedProvider=StateProvider<Color>((ref)=>AppColors.brand1);