import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/app_loading_states.dart';

import '../models/appointment_model.dart';
import '../pages/appointment_details_page.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_card.dart';

class AppointmentHistoryPage extends StatefulWidget {
  const AppointmentHistoryPage({super.key});

  @override
  State<AppointmentHistoryPage> createState() => _AppointmentHistoryPageState();
}

class _AppointmentHistoryPageState extends State<AppointmentHistoryPage> {
  late final AppointmentProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = AppointmentProvider()..fetchAppointments();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  Future<void> _openDetails(BuildContext context, AppointmentModel appointment) async {
    final result = await Navigator.push<AppointmentModel>(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetailsPage(
          appointment: appointment,
          provider: _provider,
        ),
      ),
    );

    if (result != null) {
      _provider.replaceLocal(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<AppointmentProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.cream,
            appBar: AppBar(
              backgroundColor: AppColors.cream,
              title: const Text(
                'My Appointments',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.deepTeal),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
            ),
            body: RefreshIndicator(
              color: AppColors.teal,
              onRefresh: provider.refresh,
              child: _buildBody(context, provider),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppointmentProvider provider) {
    if (provider.isLoading && provider.appointments.isEmpty) {
      return const AppListShimmer();
    }

    if (provider.error != null && provider.appointments.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Could not load appointments',
            subtitle: provider.error!,
            actionLabel: 'Retry',
            onAction: provider.fetchAppointments,
          ),
        ],
      );
    }

    if (provider.appointments.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 100),
          AppEmptyState(
            icon: Icons.event_busy_rounded,
            title: 'No appointments yet',
            subtitle: 'Book your first appointment with a vet doctor.',
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: provider.appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final appt = provider.appointments[index];
        return AppointmentCard(
          appointment: appt,
          onTap: () => _openDetails(context, appt),
        );
      },
    );
  }
}
