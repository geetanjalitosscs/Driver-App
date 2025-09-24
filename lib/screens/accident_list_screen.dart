import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accident_provider.dart';
import '../models/accident_report.dart';
import '../models/accident_filter.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/accident_filter_widget.dart';
import '../theme/app_theme.dart';

class AccidentListScreen extends StatefulWidget {
  const AccidentListScreen({super.key});

  @override
  State<AccidentListScreen> createState() => _AccidentListScreenState();
}

class _AccidentListScreenState extends State<AccidentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
      accidentProvider.loadAccidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Accident Reports'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<AccidentProvider>(
            builder: (context, accidentProvider, child) {
              return IconButton(
                onPressed: () => _showFilterDialog(accidentProvider),
                icon: Icon(
                  Icons.filter_list,
                  color: accidentProvider.currentFilter.hasActiveFilters 
                      ? Colors.white 
                      : Colors.white70,
                ),
                tooltip: 'Filter Reports',
              );
            },
          ),
          Consumer<AccidentProvider>(
            builder: (context, accidentProvider, child) {
              return IconButton(
                onPressed: () => accidentProvider.refreshAccidents(),
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              );
            },
          ),
        ],
      ),
      body: Consumer<AccidentProvider>(
        builder: (context, accidentProvider, child) {
          if (accidentProvider.isLoading) {
            return const Center(child: AppLoadingIndicator());
          }

          if (accidentProvider.errorMessage != null) {
            return _buildErrorState(accidentProvider.errorMessage!);
          }

          if (accidentProvider.accidentList.isEmpty) {
            return _buildEmptyState(accidentProvider.currentFilter.hasActiveFilters);
          }

          return Column(
            children: [
              if (accidentProvider.currentFilter.hasActiveFilters)
                _buildFilterSummary(accidentProvider.currentFilter),
              _buildReportsCount(accidentProvider.accidentList.length),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: accidentProvider.accidentList.length,
                  itemBuilder: (context, index) {
                    final accident = accidentProvider.accidentList[index];
                    return _buildAccidentCard(accident, index + 1);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: AppCard(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: AppTheme.errorRed, size: 48),
              const SizedBox(height: 16),
              Text('Error Loading Reports', style: AppTheme.heading3.copyWith(color: AppTheme.errorRed)),
              const SizedBox(height: 8),
              Text(error, style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              AppButton(
                text: 'Retry',
                onPressed: () {
                  final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
                  accidentProvider.loadAccidents();
                },
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool hasFilters) {
    return Center(
      child: AppCard(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(hasFilters ? Icons.filter_list_off : Icons.report_problem_outlined, color: AppTheme.textSecondary, size: 48),
              const SizedBox(height: 16),
              Text(hasFilters ? 'No Reports Match Filters' : 'No Accident Reports', style: AppTheme.heading3.copyWith(color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              Text(hasFilters ? 'Try adjusting your filter criteria to see more reports.' : 'No accident reports are currently available.', style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              if (hasFilters)
                AppButton(
                  text: 'Clear Filters',
                  onPressed: () {
                    final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
                    accidentProvider.clearFilters();
                  },
                  variant: AppButtonVariant.outline,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSummary(AccidentFilter filter) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: AppTheme.primaryBlue, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text('Active Filters: ${filter.filterSummary}', style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryBlue, fontWeight: FontWeight.w500))),
          TextButton(
            onPressed: () {
              final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
              accidentProvider.clearFilters();
            },
            child: Text('Clear', style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsCount(int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(Icons.list_alt, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 8),
          Text('$count Report${count != 1 ? 's' : ''} Found', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppTheme.primaryBlue)),
        ],
      ),
    );
  }

  Widget _buildAccidentCard(AccidentReport accident, int index) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: _getStatusColor(accident.status).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                  child: Center(child: Text('#$index', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold, color: _getStatusColor(accident.status)))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Report #${accident.id}', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      Text(accident.fullname, style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _getStatusColor(accident.status).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(accident.status.toUpperCase(), style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold, color: _getStatusColor(accident.status))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Location', accident.location),
            _buildDetailRow('Vehicle', accident.vehicle),
            _buildDetailRow('Date', accident.accidentDate),
            if (accident.description.isNotEmpty) _buildDetailRow('Description', accident.description),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: AppButton(text: 'View Details', variant: AppButtonVariant.outline, size: AppButtonSize.small, onPressed: () => _showAccidentDetails(accident))),
                const SizedBox(width: 8),
                if (accident.status == 'pending')
                  Expanded(child: AppButton(text: 'Accept', variant: AppButtonVariant.secondary, size: AppButtonSize.small, onPressed: () => _acceptAccident(accident))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text('$label:', style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary, fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return AppTheme.accentOrange;
      case 'accepted': return AppTheme.accentGreen;
      case 'rejected': return AppTheme.errorRed;
      case 'completed': return AppTheme.primaryBlue;
      case 'cancelled': return Colors.grey;
      default: return Colors.grey;
    }
  }

  Future<void> _showFilterDialog(AccidentProvider accidentProvider) async {
    final newFilter = await FilterBottomSheet.show(context, accidentProvider.currentFilter);
    if (newFilter != null) {
      accidentProvider.applyFilter(newFilter);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newFilter.hasActiveFilters ? 'Filters applied: ${newFilter.filterSummary}' : 'All filters cleared'),
          backgroundColor: AppTheme.primaryBlue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAccidentDetails(AccidentReport accident) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AppCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Accident Report Details', style: AppTheme.heading3),
                const SizedBox(height: 16),
                _buildDetailRow('ID', accident.id.toString()),
                _buildDetailRow('Name', accident.fullname),
                _buildDetailRow('Phone', accident.phone),
                _buildDetailRow('Vehicle', accident.vehicle),
                _buildDetailRow('Date', accident.accidentDate),
                _buildDetailRow('Location', accident.location),
                _buildDetailRow('Status', accident.status),
                if (accident.description.isNotEmpty) _buildDetailRow('Description', accident.description),
                const SizedBox(height: 20),
                AppButton(text: 'Close', onPressed: () => Navigator.of(context).pop(), variant: AppButtonVariant.primary, isFullWidth: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _acceptAccident(AccidentReport accident) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Accident #${accident.id} accepted'), backgroundColor: AppTheme.accentGreen),
    );
  }
}