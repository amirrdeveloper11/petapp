import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/app_loading_states.dart';
import 'package:front/widgets/app_section_header.dart';

import '../providers/doctor_list_provider.dart';
import '../widgets/doctor_card.dart';
import '../widgets/specialty_filter_chips.dart';
import 'doctor_details_page.dart';

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorListProvider>(
      builder: (context, p, _) {
        final doctors = p.filteredDoctors;

        return Scaffold(
          backgroundColor: AppColors.cream,
          body: RefreshIndicator(
            color: AppColors.teal,
            onRefresh: p.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: AppSectionHeader(
                      title: 'Veterinarians',
                      subtitle: 'Book trusted care for your pet',
                      leadingIcon: Icons.medical_services_rounded,
                    ),
                  ),
                ),
                SpecialtyFilterChips(
                  specialties: p.specialties,
                  selectedId: p.selectedSpecialtyId,
                  onSelected: p.selectSpecialty,
                ),
                const SizedBox(height: 16),
                if (p.loading && p.doctors.isEmpty)
                  const AppListShimmer(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  )
                else if (p.error != null && p.doctors.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppEmptyState(
                      icon: Icons.error_outline_rounded,
                      title: 'Could not load veterinarians',
                      subtitle: p.error!,
                      actionLabel: 'Retry',
                      onAction: p.load,
                    ),
                  )
                else if (doctors.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: AppEmptyState(
                      icon: Icons.medical_services_outlined,
                      title: 'No veterinarians found',
                      subtitle: 'Try another specialty or pull to refresh.',
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DoctorDetailsPage(doctorId: doctor.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
