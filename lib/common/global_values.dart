import 'package:flutter/material.dart';
import 'package:vepay_app/models/app_info_model.dart';
import 'package:vepay_app/models/member_model.dart';

var currentMemberGlobal = ValueNotifier<MemberModel>(MemberModel());

var appInfoGlobal = ValueNotifier<List<AppInfoModel>>([]);
