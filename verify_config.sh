#!/bin/bash

# DoseMate Configuration Verification Script
# This script checks if all required configurations are in place

echo "🔍 DoseMate Configuration Check"
echo "================================"
echo ""

# Check entitlements file
if [ -f "DoseMate/DoseMate/DoseMate.entitlements" ]; then
    echo "✅ Entitlements file exists"
    if grep -q "com.apple.developer.healthkit" "DoseMate/DoseMate/DoseMate.entitlements"; then
        echo "✅ HealthKit capability enabled"
    else
        echo "❌ HealthKit capability missing"
    fi
    if grep -q "aps-environment" "DoseMate/DoseMate/DoseMate.entitlements"; then
        echo "✅ Push Notifications capability enabled"
    else
        echo "❌ Push Notifications capability missing"
    fi
else
    echo "❌ Entitlements file not found"
fi

echo ""

# Check Info.plist
if [ -f "DoseMate/DoseMate/Info.plist" ]; then
    echo "✅ Info.plist exists"
    if grep -q "NSHealthShareUsageDescription" "DoseMate/DoseMate/Info.plist"; then
        echo "✅ HealthKit share description present"
    else
        echo "❌ HealthKit share description missing"
    fi
    if grep -q "NSHealthUpdateUsageDescription" "DoseMate/DoseMate/Info.plist"; then
        echo "✅ HealthKit update description present"
    else
        echo "❌ HealthKit update description missing"
    fi
else
    echo "❌ Info.plist not found"
fi

echo ""

# Check key Swift files
FILES=(
    "DoseMate/DoseMate/Services/HealthKitManager.swift"
    "DoseMate/DoseMate/Services/NotificationManager.swift"
    "DoseMate/DoseMate/DoseMateApp.swift"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

echo ""
echo "================================"
echo "Configuration check complete!"
echo ""
echo "📝 Next steps:"
echo "1. Open DoseMate.xcodeproj in Xcode"
echo "2. Select your development team"
echo "3. Choose a simulator or device"
echo "4. Press ⌘+R to build and run"
echo ""
