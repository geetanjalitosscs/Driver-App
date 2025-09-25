# Database Files

This folder contains all SQL files for the Driver App database setup and management.

## Database Setup Files

### Core Setup
- **`complete_database_setup.sql`** - Complete database schema with all tables, triggers, and initial data
- **`edueyeco_apatkal.sql`** - Full database dump with sample data (backup)
- **`mysql_user_setup.sql`** - MySQL user creation and permissions

## Table Modifications

### Earnings Table
- **`add_trip_id_to_earnings.sql`** - Adds trip_id column to earnings table (required for linking earnings to trips)

### Trips Table
- **`update_trips_table.sql`** - Adds location tracking fields (latitude/longitude) to trips table

### Wallet
- **`update_wallet_balance_trigger.sql`** - Creates trigger for automatic wallet balance updates

## Sample Data
- **`sample_earnings_wallet_data.sql`** - Sample earnings and wallet data for testing

## Usage Instructions

1. **For New Setup**: Use `complete_database_setup.sql` for a complete fresh installation
2. **For Updates**: Apply individual modification files as needed:
   - Run `add_trip_id_to_earnings.sql` to link earnings to trips
   - Run `update_trips_table.sql` to add location tracking
   - Run `update_wallet_balance_trigger.sql` for automatic wallet updates
3. **For Testing**: Use `sample_earnings_wallet_data.sql` to add test data
4. **For Backup**: Use `edueyeco_apatkal.sql` as a complete database backup

## Database Structure

The database includes the following main tables:
- `drivers` - Driver information and authentication
- `trips` - Trip records and history
- `earnings` - Driver earnings from trips
- `wallet` - Driver wallet balances
- `withdrawals` - Withdrawal requests and history
- `bank_accounts` - Driver bank account information

## Notes

- All SQL files are compatible with MySQL/MariaDB
- Use `mysql_user_setup.sql` to create the database user
- The `complete_database_setup.sql` file includes all necessary tables, triggers, and sample data
