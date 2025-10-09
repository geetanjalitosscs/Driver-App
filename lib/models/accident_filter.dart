class AccidentFilter {
  final String? city;
  final String? description;
  final String? vehicle;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  AccidentFilter({
    this.city,
    this.description,
    this.vehicle,
    this.dateFrom,
    this.dateTo,
  });

  /// Create a copy with updated values
  AccidentFilter copyWith({
    String? city,
    String? description,
    String? vehicle,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return AccidentFilter(
      city: city ?? this.city,
      description: description ?? this.description,
      vehicle: vehicle ?? this.vehicle,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
    );
  }

  /// Check if any filter is active
  bool get hasActiveFilters {
    return city != null ||
        description != null ||
        vehicle != null ||
        dateFrom != null ||
        dateTo != null;
  }

  /// Clear all filters
  AccidentFilter clear() {
    return AccidentFilter();
  }

  /// Get filter summary for display
  String get filterSummary {
    List<String> activeFilters = [];
    
    if (city != null) activeFilters.add('City: $city');
    if (description != null) activeFilters.add('Description: $description');
    if (vehicle != null) activeFilters.add('Vehicle: $vehicle');
    if (dateFrom != null) activeFilters.add('From: ${_formatDate(dateFrom!)}');
    if (dateTo != null) activeFilters.add('To: ${_formatDate(dateTo!)}');
    
    return activeFilters.join(', ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  String toString() {
    return 'AccidentFilter(city: $city, description: $description, vehicle: $vehicle, dateFrom: $dateFrom, dateTo: $dateTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccidentFilter &&
        other.city == city &&
        other.description == description &&
        other.vehicle == vehicle &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        description.hashCode ^
        vehicle.hashCode ^
        dateFrom.hashCode ^
        dateTo.hashCode;
  }
}
