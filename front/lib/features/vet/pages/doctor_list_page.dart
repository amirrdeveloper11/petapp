import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/doctor_list_provider.dart';
import '../widgets/doctor_card.dart';
import '../widgets/specialty_filter_chips.dart';
import 'doctor_details_page.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/app_shimmer.dart';
import 'package:front/widgets/custom_button.dart';

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorListProvider>(
      builder: (context, p, _) {
        final doctors = p.filteredDoctors;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Veterinarians',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            surfaceTintColor: Colors.transparent,
          ),
          body: RefreshIndicator(
            onRefresh: p.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const SizedBox(height: 12),
                SpecialtyFilterChips(
                  specialties: p.specialties,
                  selectedId: p.selectedSpecialtyId,
                  onSelected: p.selectSpecialty,
                ),
                const SizedBox(height: 12),
                if (p.loading && p.doctors.isEmpty)
                  _buildLoading()
                else if (p.error != null && p.doctors.isEmpty)
                  _buildError(context, p)
                else if (doctors.isEmpty)
                  const AppEmptyState(
                    icon: Icons.medical_services_outlined,
                    title: 'No veterinarians found',
                    subtitle: 'Try another specialty or pull to refresh.',
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorDetailsPage(doctorId: doctor.id),
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

  Widget _buildLoading() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const AppShimmer(height: 96, width: double.infinity),
    );
  }

  Widget _buildError(BuildContext context, DoctorListProvider p) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Could not load veterinarians',
            subtitle: p.error!,
          ),
          const SizedBox(height: 16),
          CustomButton(text: 'Retry', onPressed: p.load),
        ],
      ),
    );
  }
}
