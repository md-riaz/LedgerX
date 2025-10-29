# LedgerX User Guide

## Table of Contents
1. [Getting Started](#getting-started)
2. [Features Overview](#features-overview)
3. [Customer Management](#customer-management)
4. [Entry Management](#entry-management)
5. [Search & Filters](#search--filters)
6. [Import/Export](#importexport)
7. [Backup & Restore](#backup--restore)
8. [Keyboard Shortcuts](#keyboard-shortcuts)
9. [Audit Logs](#audit-logs)
10. [Settings](#settings)

## Getting Started

### First Launch
When you first launch LedgerX, you'll see the Dashboard with four main sections:
- **Customers**: Manage your customer database
- **Entries**: Track credit and debit transactions
- **Credits**: View total credit entries
- **Debits**: View total debit entries

### Quick Navigation
Use the top navigation bar to move between:
- Home Dashboard
- Customers List
- Entries List
- Settings

## Features Overview

### Core Features
- **Offline-First**: All data is stored locally using SQLite
- **Encrypted Storage**: Database is secured with AES encryption
- **Real-Time Balance**: Automatic balance calculation per customer
- **Cross-Platform**: Works on Windows, Linux, macOS, Android, and iOS

### Security Features
- AES file encryption for the database
- Audit logging for all operations
- Secure data storage

## Customer Management

### Adding a Customer
1. Navigate to **Customers** page
2. Click the **+** floating action button
3. Fill in the customer details:
   - Name (required)
   - Email (optional)
   - Phone (optional)
   - Address (optional)
4. Click **Add** to save

### Editing a Customer
1. Click on any customer in the list
2. View customer details in the bottom sheet
3. Click **Edit** to modify information
4. Save changes

### Deleting a Customer
1. Click the delete icon next to the customer
2. Confirm deletion in the dialog
3. All related entries will also be deleted (cascade delete)

### Searching Customers
Use the search bar at the top of the Customers page to filter by:
- Customer name
- Email address
- Phone number

## Entry Management

### Creating an Entry
1. Navigate to **Entries** page
2. Click the **+** floating action button
3. Select the customer
4. Choose entry type (Credit or Debit)
5. Enter the amount
6. Add description (optional)
7. Add tags (comma-separated, optional)
8. Select date
9. Click **Add** to save

### Entry Types
- **Credit**: Money received (adds to balance)
- **Debit**: Money paid out (subtracts from balance)

### Viewing Balance
When viewing entries for a specific customer, the current balance is displayed at the top:
- Green indicates positive balance (customer owes you)
- Red indicates negative balance (you owe customer)

### Tags
Tags help organize and categorize entries:
- Add multiple tags separated by commas
- Search entries by tags
- Filter entries using tags

## Search & Filters

### Quick Search
- **Customers**: Search by name, email, or phone
- **Entries**: Search by description or tags
- Real-time filtering as you type

### Advanced Filtering
- Filter entries by customer
- Filter by date range
- Filter by entry type (credit/debit)

## Import/Export

### CSV Import (Customers)
1. Go to **Customers** page
2. Click the upload icon in the app bar
3. Select a CSV file with format:
   ```
   Name, Email, Phone, Address
   John Doe, john@example.com, 1234567890, 123 Main St
   ```
4. Customers will be imported automatically

### CSV Export (Customers)
1. Go to **Customers** page
2. Click the download icon
3. CSV file will be generated with all customer data

### PDF Export (Entries)
1. Go to **Entries** page
2. Click the PDF icon in the app bar
3. Generate invoices or reports
4. Print or save to file

#### Available PDF Reports:
- **Customer Invoice**: Detailed transaction history for a customer
- **Ledger Report**: Complete ledger with all customers and balances

## Backup & Restore

### Creating a Backup
1. Go to **Settings**
2. Select **Backup Data**
3. Choose a location to save the backup
4. Database file will be copied to the selected location

### Restoring from Backup
1. Go to **Settings**
2. Select **Restore Data**
3. Choose a backup file (.db)
4. Confirm restoration
5. App will restart with restored data

### Best Practices
- Create regular backups (weekly recommended)
- Store backups in multiple locations
- Test your backups periodically

## Keyboard Shortcuts

LedgerX includes powerful keyboard shortcuts for desktop users:

### Navigation
- `Ctrl + H`: Go to Home
- `Ctrl + Shift + C`: Go to Customers
- `Ctrl + Shift + E`: Go to Entries
- `Ctrl + Shift + S`: Go to Settings

### Quick Actions
- `Ctrl + N`: Create new item (customer or entry based on current page)
- `Ctrl + F`: Focus search field
- `Ctrl + T`: Toggle dark/light theme

### Help
- `F1`: Show keyboard shortcuts reference

## Audit Logs

### Viewing Audit Logs
1. Go to **Settings**
2. Select **Audit Logs**
3. View complete activity history

### What's Logged
- All CREATE operations (new customers, entries)
- All UPDATE operations (modifications)
- All DELETE operations (deletions)
- Timestamps for all actions
- Entity types and IDs

### Audit Visualization
- Pie chart showing action distribution
- Timeline of activities
- Detailed log entries with descriptions

### Using Audit Logs
- Track all changes to data
- Identify patterns in usage
- Debug issues
- Maintain compliance records

## Settings

### Theme Settings
Switch between light and dark modes:
1. Go to **Settings**
2. Toggle **Dark Mode** switch
3. Theme changes immediately

### Data Management
- **Backup Data**: Create database backup
- **Restore Data**: Restore from backup
- **Audit Logs**: View activity history

### About
- View app version
- Read license information
- Contact support

## Tips & Best Practices

### For Small Businesses
1. Create customers for all clients
2. Add entries immediately after transactions
3. Use tags to categorize expenses/income
4. Generate monthly PDF reports
5. Regular backups (weekly)

### For Personal Use
1. Track loans to friends/family
2. Monitor shared expenses
3. Keep records of payments
4. Use reminders for due dates

### Data Organization
1. Use consistent naming for customers
2. Add tags to all entries for easy filtering
3. Include detailed descriptions
4. Regular data cleanup

### Performance Tips
1. Archive old data periodically
2. Use search instead of scrolling
3. Limit entries shown per page
4. Clean up unused tags

## Troubleshooting

### Common Issues

#### App Won't Start
- Check if database file is not corrupted
- Try restoring from backup
- Reinstall the application

#### Cannot Import CSV
- Check CSV format matches template
- Ensure file encoding is UTF-8
- Verify no special characters in data

#### PDF Export Not Working
- Check file permissions
- Ensure sufficient disk space
- Try exporting smaller date ranges

#### Search Not Working
- Clear search field and try again
- Check for typos
- Ensure data exists

### Getting Help
- Check this user guide
- View keyboard shortcuts (F1)
- Contact support at: support@ledgerx.app

## Advanced Features

### Running Balance Calculation
The balance is calculated in real-time:
```
Balance = Sum(Credits) - Sum(Debits)
```

### Database Encryption
- All data is encrypted using AES-256
- Encryption key is managed securely
- Data is encrypted at rest

### Audit Trail
Every action is logged with:
- Action type (CREATE/UPDATE/DELETE)
- Entity type (Customer/Entry)
- Entity ID
- Timestamp
- Details/description

## Appendix

### Keyboard Shortcut Reference Card

| Shortcut | Action |
|----------|--------|
| Ctrl + H | Home |
| Ctrl + Shift + C | Customers |
| Ctrl + Shift + E | Entries |
| Ctrl + Shift + S | Settings |
| Ctrl + N | New Item |
| Ctrl + F | Search |
| Ctrl + T | Toggle Theme |
| F1 | Help |

### CSV Import Format

#### Customers
```csv
Name,Email,Phone,Address
John Doe,john@example.com,1234567890,123 Main St
Jane Smith,jane@example.com,0987654321,456 Oak Ave
```

### Supported Platforms
- ✅ Windows 10/11
- ✅ Linux (Ubuntu, Fedora, etc.)
- ✅ macOS 10.14+
- ✅ Android 5.0+ (API 21+)
- ✅ iOS 12.0+
- ✅ Web (Chrome, Firefox, Safari)

---

**Version**: 1.0.0  
**Last Updated**: 2024  
**Copyright**: © 2024 LedgerX. All rights reserved.
