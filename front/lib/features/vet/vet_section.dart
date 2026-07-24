import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/doctor_list_page.dart';
import 'providers/doctor_list_provider.dart';

class VetSection extends StatelessWidget {
  const VetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorListProvider()..load(),
      child: const DoctorListPage(),
    );
  }
}
