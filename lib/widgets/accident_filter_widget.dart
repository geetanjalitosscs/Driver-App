import 'package:flutter/material.dart';
import '../models/accident_filter.dart';
import '../theme/app_theme.dart';

class AccidentFilterWidget extends StatefulWidget {
  final AccidentFilter currentFilter;
  final Function(AccidentFilter) onFilterChanged;
  final VoidCallback? onClearFilters;

  const AccidentFilterWidget({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    this.onClearFilters,
  });

  @override
  State<AccidentFilterWidget> createState() => _AccidentFilterWidgetState();
}

class _AccidentFilterWidgetState extends State<AccidentFilterWidget> {
  late AccidentFilter _filter;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();

  // Predefined options
  final List<String> _cityOptions = [
    'All',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Surat',
    'Jabalpur',
    'Indore',
    'Bhopal',
    'Gwalior',
  ];

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _initializeControllers();
  }

  void _initializeControllers() {
    _cityController.text = _filter.city ?? '';
    _descriptionController.text = _filter.description ?? '';
    _vehicleController.text = _filter.vehicle ?? '';
  }

  @override
  void dispose() {
    _cityController.dispose();
    _descriptionController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  void _updateFilter() {
    widget.onFilterChanged(_filter);
  }

  void _clearFilters() {
    setState(() {
      _filter = AccidentFilter();
      _cityController.clear();
      _descriptionController.clear();
      _vehicleController.clear();
    });
    widget.onClearFilters?.call();
    _updateFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              // Back button
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                color: AppTheme.primaryBlue,
                iconSize: 24,
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.filter_list,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Filter Reports',
                style: AppTheme.heading3.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
              const Spacer(),
              if (_filter.hasActiveFilters)
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.accentRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // City Filter
          _buildSectionTitle('City'),
          const SizedBox(height: 8),
          _buildCityFilter(),
          const SizedBox(height: 16),

          // Description Filter
          _buildSectionTitle('Description Keywords'),
          const SizedBox(height: 8),
          _buildDescriptionFilter(),
          const SizedBox(height: 16),

          // Vehicle Number Filter
          _buildSectionTitle('Vehicle Number'),
          const SizedBox(height: 8),
          _buildVehicleFilter(),
          const SizedBox(height: 20),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _updateFilter();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Apply Filters',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Active Filters Summary
          if (_filter.hasActiveFilters) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryBlue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Active: ${_filter.filterSummary}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCityFilter() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return _cityOptions.where((String option) => option != 'All');
        }
        return _cityOptions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase()) && option != 'All';
        });
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Enter city name or select from dropdown',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            prefixIcon: const Icon(Icons.location_city, size: 20),
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: () {
                // This will trigger the dropdown
                focusNode.requestFocus();
              },
            ),
          ),
          onChanged: (String value) {
            setState(() {
              _filter = _filter.copyWith(city: value.isEmpty ? null : value);
            });
          },
        );
      },
      onSelected: (String selection) {
        setState(() {
          _filter = _filter.copyWith(city: selection == 'All' ? null : selection);
        });
      },
    );
  }


  Widget _buildDescriptionFilter() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        hintText: 'Enter keywords (e.g., collision, injury, damage)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        prefixIcon: const Icon(Icons.search, size: 20),
      ),
      onChanged: (String value) {
        setState(() {
          _filter = _filter.copyWith(description: value.isEmpty ? null : value);
        });
      },
    );
  }

  Widget _buildVehicleFilter() {
    return TextFormField(
      controller: _vehicleController,
      decoration: InputDecoration(
        hintText: 'Enter vehicle number (e.g., MP20AB1234, DL01AB1234)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        prefixIcon: const Icon(Icons.confirmation_number, size: 20),
      ),
      onChanged: (String value) {
        setState(() {
          _filter = _filter.copyWith(vehicle: value.isEmpty ? null : value);
        });
      },
    );
  }

}

/// Filter Bottom Sheet
class FilterBottomSheet {
  static Future<AccidentFilter?> show(
    BuildContext context,
    AccidentFilter currentFilter,
  ) async {
    AccidentFilter? resultFilter;
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Filter content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: AccidentFilterWidget(
                    currentFilter: currentFilter,
                    onFilterChanged: (filter) {
                      resultFilter = filter;
                    },
                    onClearFilters: () {
                      resultFilter = AccidentFilter();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    return resultFilter;
  }
}
