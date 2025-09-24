class AccidentFilter {
  final String? city;
  final String? status;
  final String? description;
  final String? vehicle;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? severity;

  AccidentFilter({
    this.city,
    this.status,
    this.description,
    this.vehicle,
    this.dateFrom,
    this.dateTo,
    this.severity,
  });

  /// Create a copy with updated values
  AccidentFilter copyWith({
    String? city,
    String? status,
    String? description,
    String? vehicle,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? severity,
  }) {
    return AccidentFilter(
      city: city ?? this.city,
      status: status ?? this.status,
      description: description ?? this.description,
      vehicle: vehicle ?? this.vehicle,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      severity: severity ?? this.severity,
    );
  }

  /// Check if any filter is active
  bool get hasActiveFilters {
    return city != null ||
        status != null ||
        description != null ||
        vehicle != null ||
        dateFrom != null ||
        dateTo != null ||
        severity != null;
  }

  /// Clear all filters
  AccidentFilter clear() {
    return AccidentFilter();
  }

  /// Get filter summary for display
  String get filterSummary {
    List<String> activeFilters = [];
    
    if (city != null) activeFilters.add('City: $city');
    if (status != null) activeFilters.add('Status: $status');
    if (description != null) activeFilters.add('Description: $description');
    if (vehicle != null) activeFilters.add('Vehicle: $vehicle');
    if (severity != null) activeFilters.add('Severity: $severity');
    if (dateFrom != null) activeFilters.add('From: ${_formatDate(dateFrom!)}');
    if (dateTo != null) activeFilters.add('To: ${_formatDate(dateTo!)}');
    
    return activeFilters.join(', ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  String toString() {
    return 'AccidentFilter(city: $city, status: $status, description: $description, vehicle: $vehicle, dateFrom: $dateFrom, dateTo: $dateTo, severity: $severity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccidentFilter &&
        other.city == city &&
        other.status == status &&
        other.description == description &&
        other.vehicle == vehicle &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo &&
        other.severity == severity;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        status.hashCode ^
        description.hashCode ^
        vehicle.hashCode ^
        dateFrom.hashCode ^
        dateTo.hashCode ^
        severity.hashCode;
  }
}
