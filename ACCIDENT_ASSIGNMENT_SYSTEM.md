# Accident Report Assignment System

## Overview
This system implements a dynamic radius-based accident report assignment logic that shows accident reports to the nearest available drivers within an expanding radius.

## Key Features

### 1. Dynamic Radius Expansion
- **Initial Radius**: 5 meters (0.005 km)
- **Expansion Rate**: +5 meters every 15 seconds
- **Maximum Radius**: 10 km
- **Calculation**: Based on `created_at` timestamp in accidents table

### 2. Driver Assignment Logic
- Shows accident reports to nearest available drivers within current radius
- Drivers can accept or reject assignments
- If rejected/cancelled, accident becomes available for next driver
- Same dynamic radius logic continues for reassignment

### 3. API Endpoints

#### `submit_accident_report.php`
- **Purpose**: Submit new accident reports
- **Method**: POST
- **Required Fields**: fullname, phone, vehicle, accident_date, location, latitude, longitude, description
- **Response**: Returns accident_id and assignment info

#### `get_driver_nearby_accidents.php`
- **Purpose**: Get accidents visible to a specific driver
- **Method**: GET
- **Parameters**: driver_id
- **Features**: 
  - Uses dynamic radius calculation
  - Shows accidents within driver's current radius
  - Includes radius expansion information

#### `find_available_drivers.php`
- **Purpose**: Find available drivers for a specific accident
- **Method**: POST
- **Required Fields**: accident_id
- **Features**:
  - Calculates dynamic radius for the accident
  - Finds drivers within that radius
  - Orders by distance (nearest first)

#### `manage_driver_assignment.php`
- **Purpose**: Handle driver assignment, rejection, and cancellation
- **Method**: POST
- **Actions**:
  - `assign_driver`: Assign a driver to an accident
  - `reject_assignment`: Driver rejects assignment (makes available for others)
  - `cancel_assignment`: Cancel assignment (makes available for others)

#### `accident_assignment_workflow.php`
- **Purpose**: Comprehensive workflow management
- **Method**: POST
- **Actions**: All of the above actions in one endpoint

## Workflow Process

### 1. Accident Report Submission
```
Client submits accident report
↓
Stored in accidents table with status='pending'
↓
System calculates initial radius (500m)
```

### 2. Driver Assignment
```
System finds nearest available drivers within radius
↓
Shows accident to drivers in order of distance
↓
Driver can accept or reject
```

### 3. Radius Expansion
```
If all drivers reject or no drivers found
↓
Wait 15 seconds from accident creation time
↓
Increase radius by 5m
↓
Repeat assignment process
```

### 4. Assignment Management
```
If driver accepts: status='investigating', driver_status='assigned'
If driver rejects: Reset to status='pending' for next driver
If assignment cancelled: Reset to status='pending' for next driver
```

## Database Schema

### Accidents Table
- `id`: Primary key
- `fullname`, `phone`, `vehicle`: Client details
- `accident_date`: Date of accident
- `location`, `latitude`, `longitude`: Location details
- `description`: Accident description
- `created_at`: Timestamp for radius calculation
- `status`: 'pending', 'investigating', 'resolved'
- `driver_status`: 'assigned', 'completed', NULL
- `driver_details`: Driver info when assigned
- `accepted_at`: When driver accepted
- `completed_at`: When accident resolved

### Drivers Table
- `id`: Primary key
- `driver_name`: Driver name
- `phone`: Driver phone
- `vehicle_number`: Vehicle number
- `status`: 'active', 'inactive'

### Driver Locations Table
- `driver_id`: Foreign key to drivers
- `latitude`, `longitude`: Current location
- `updated_at`: Last location update

## Usage Examples

### Submit Accident Report
```json
POST /api/submit_accident_report.php
{
    "fullname": "John Doe",
    "phone": "9876543210",
    "vehicle": "MP20ZE3605",
    "accident_date": "2025-01-15",
    "location": "Main Street, City",
    "latitude": 23.123456,
    "longitude": 77.654321,
    "description": "Car accident with injuries"
}
```

### Get Available Drivers
```json
POST /api/find_available_drivers.php
{
    "accident_id": 123
}
```

### Assign Driver
```json
POST /api/manage_driver_assignment.php
{
    "action": "assign_driver",
    "accident_id": 123,
    "driver_id": 456,
    "vehicle_number": "MP20ZE3605"
}
```

### Reject Assignment
```json
POST /api/manage_driver_assignment.php
{
    "action": "reject_assignment",
    "accident_id": 123,
    "driver_id": 456,
    "reason": "Too far from current location"
}
```

## Important Notes

1. **Not Automatic Assignment**: This system shows reports to drivers, but drivers must manually accept/reject
2. **Radius Calculation**: Based on accident creation time, not assignment time
3. **Driver Availability**: Only active drivers with recent location updates are considered
4. **Reassignment**: When rejected/cancelled, accident immediately becomes available for next driver
5. **Maximum Radius**: System caps at 10km to prevent excessive expansion
6. **Fast Expansion**: Radius increases every 15 seconds for quick driver assignment
7. **Small Initial Radius**: Starts with only 5 meters for very precise initial assignment

## Error Handling

- All endpoints include comprehensive error handling
- Database errors are logged for debugging
- Invalid inputs return appropriate error messages
- Failed operations are clearly communicated to clients
