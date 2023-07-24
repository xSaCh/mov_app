library globals;

import 'package:flutter/material.dart';
import 'package:linux_test/utils/user.dart';

User globalUser = User(101);
ValueNotifier<bool> userChange = ValueNotifier<bool>(false);
