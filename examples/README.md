# LedgerX Examples

This directory contains example files for testing and demonstration purposes.

## Sample Files

### sample_customers.csv
A sample CSV file with 10 customers that you can use to test the import functionality.

**How to use:**
1. Open LedgerX application
2. Navigate to Customers page
3. Click the upload icon in the app bar
4. Select `sample_customers.csv`
5. Customers will be imported automatically

**Format:**
```csv
Name,Email,Phone,Address
John Doe,john.doe@example.com,555-0100,123 Main Street
```

## Creating Your Own CSV Files

### Customer Import Format
Your CSV file should have the following columns in order:
1. **Name** (required): Customer's full name
2. **Email** (optional): Customer's email address
3. **Phone** (optional): Customer's phone number
4. **Address** (optional): Customer's physical address

**Important Notes:**
- First row should be the header row (Name,Email,Phone,Address)
- Name field is required, others are optional
- Use commas to separate fields
- If a field contains a comma, wrap it in quotes: "123 Main St, Apt 4"
- File encoding should be UTF-8

### Example CSV Templates

#### Minimal Format (Name only)
```csv
Name,Email,Phone,Address
John Doe,,,
Jane Smith,,,
Bob Johnson,,,
```

#### With Email
```csv
Name,Email,Phone,Address
John Doe,john@example.com,,
Jane Smith,jane@example.com,,
```

#### Complete Format
```csv
Name,Email,Phone,Address
John Doe,john@example.com,555-0100,123 Main St
Jane Smith,jane@example.com,555-0101,456 Oak Ave
```

## Best Practices

1. **Backup First**: Always backup your data before importing
2. **Test with Small File**: Test with a few rows first
3. **Check Format**: Ensure CSV format matches the template
4. **Encoding**: Save as UTF-8 to avoid special character issues
5. **Clean Data**: Remove duplicate entries before importing

## Common Issues

### Issue: Import fails
- Check that the first row is the header
- Ensure file is UTF-8 encoded
- Verify no special characters in data

### Issue: Empty fields
- Empty optional fields are OK
- Name field must not be empty

### Issue: Duplicate customers
- The app will import all rows, even duplicates
- Clean up duplicates before importing

## Generating Your Own CSV

### Using Excel
1. Create a spreadsheet with columns: Name, Email, Phone, Address
2. Enter your data
3. File > Save As > CSV (Comma delimited) (*.csv)
4. Select UTF-8 encoding if available

### Using Google Sheets
1. Create a spreadsheet with columns: Name, Email, Phone, Address
2. Enter your data
3. File > Download > Comma-separated values (.csv)

### Using a Text Editor
1. Create a new text file
2. Add header row: Name,Email,Phone,Address
3. Add data rows, one per line
4. Save as .csv file with UTF-8 encoding

## Need More Examples?

Create your own based on these templates or contact us for help:
- Email: support@ledgerx.app
- GitHub: https://github.com/md-riaz/LedgerX/issues

---

**Note**: The sample data provided is fictional and for demonstration purposes only.
