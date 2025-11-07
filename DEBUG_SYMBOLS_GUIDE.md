# Google Play Console Debug Symbols Upload Guide

## Problem
You received this warning from Google Play Console:
> "App Bundle ini berisi kode native, dan Anda belum mengupload simbol debug. Sebaiknya Anda mengupload file simbol agar error dan ANR Anda lebih mudah untuk dianalisis serta di-debug."

This means your App Bundle contains native code but you haven't uploaded debug symbols for crash analysis.

## Solution Implemented

### 1. Build Configuration Updates

**Updated `android/app/build.gradle`:**
- Added `debugSymbolLevel 'FULL'` for complete symbol generation
- Configured `packagingOptions` to preserve native symbols
- Set proper debug flags for release builds

### 2. Native Debug Symbols Collection

**Created automated script:** `collect_symbols.ps1`
- Automatically locates built native libraries
- Collects symbols for all architectures (ARM64, ARMv7, x86, x86_64)
- Creates a properly formatted zip file for Google Play Console

### 3. Generated Files

✅ **native-debug-symbols.zip** (25.14 MB)
- Contains debug symbols for all supported architectures
- Ready for upload to Google Play Console

## How to Upload Debug Symbols

### Step 1: Build Your Release
```bash
flutter build appbundle --release
```

### Step 2: Collect Symbols
```bash
PowerShell -ExecutionPolicy Bypass -File .\collect_symbols.ps1
```

### Step 3: Upload to Google Play Console

1. **Go to Google Play Console**
   - Navigate to your app
   - Go to the specific release (Production, Beta, etc.)

2. **Find the Native Debug Symbols Section**
   - Look for "Native debug symbols" or "Simbol debug native"
   - This is usually in the release details or artifacts section

3. **Upload the Symbols File**
   - Click "Upload" or "Browse"
   - Select `native-debug-symbols.zip`
   - Wait for upload to complete

4. **Verify Upload**
   - Confirm the upload shows as successful
   - The warning should disappear in subsequent releases

## What This Fixes

✅ **Crash Analysis**: Google Play Console can now properly analyze crashes  
✅ **ANR Debugging**: Application Not Responding issues will have detailed stack traces  
✅ **Performance Monitoring**: Better insights into native code performance  
✅ **Warning Removal**: Eliminates the debug symbols warning  

## Architecture Support

The generated symbols include:
- **ARM64-v8a**: Modern 64-bit ARM processors (most current devices)
- **ARMv7a**: 32-bit ARM processors (older devices)
- **x86**: Intel 32-bit (emulators)
- **x86_64**: Intel 64-bit (emulators, some tablets)

## Files Included in Symbols

- `libapp.so`: Your Flutter app's compiled Dart code
- `libflutter.so`: Flutter engine native code
- `libdatastore_shared_counter.so`: SharedPreferences native implementation

## Automation for Future Releases

For future releases, simply run:
```bash
# Build the release
flutter build appbundle --release

# Collect symbols
PowerShell -ExecutionPolicy Bypass -File .\collect_symbols.ps1

# Upload the generated native-debug-symbols.zip to Play Console
```

## Notes

- Debug symbols are only needed for release builds uploaded to Play Console
- The symbols file will be different for each build, so generate fresh symbols for each release
- Uploading symbols is optional but highly recommended for production apps
- This process doesn't affect your app size - symbols are stored separately by Google
