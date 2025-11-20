#!/bin/bash

echo "════════════════════════════════════════════════════════════════════"
echo "           🎨 REGENERATING SIMPLIFIED DIAGRAMS"
echo "════════════════════════════════════════════════════════════════════"
echo ""

cd "$(dirname "$0")"

# Regenerate all PNG files from simplified .mmd sources
echo "📊 Regenerating PNGs from simplified Mermaid sources..."
echo ""

for dir in 01_requirements 02_structure 03_behavior 04_parametric; do
  if [ -d "$dir" ]; then
    echo "📁 Processing $dir/"
    cd "$dir"
    # Process subdirectories
    for subdir in */; do
      if [ -d "$subdir" ]; then
        echo "📁 Processing ${subdir}"
        cd "$subdir"

        for mmd in *.mmd; do
          if [ -f "$mmd" ]; then
            png="${mmd%.mmd}.png"
            echo "  ✓ $mmd → $png"
            mmdc -i "$mmd" -o "$png" -w 1200 -H 800 -s 3 2>/dev/null || echo "    ⚠ Warning: conversion issue"
          fi
        done
        cd ..
      fi
    done
    
    for mmd in *.mmd; do
      if [ -f "$mmd" ]; then
        png="${mmd%.mmd}.png"
        echo "  ✓ $mmd → $png"
        mmdc -i "$mmd" -o "$png" -w 1200 -H 800 -s 3 2>/dev/null || echo "    ⚠ Warning: conversion issue"
      fi
    done
    cd ..
    echo ""
  fi
done

echo "════════════════════════════════════════════════════════════════════"
echo "           📊 FILE SIZE COMPARISON"
echo "════════════════════════════════════════════════════════════════════"
echo ""

echo "Largest diagrams (should now be < 200KB):"
du -h */sysml-*.png | sort -rh | head -10

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "           ✅ DIAGRAM REGENERATION COMPLETE"
echo "════════════════════════════════════════════════════════════════════"
echo ""
echo "📈 Total diagram count:"
find . -name "*.png" -type f | wc -l | xargs echo "PNG files:"
find . -name "*.mmd" -type f | wc -l | xargs echo "Mermaid sources:"
echo ""
echo "💾 Total size:"
du -sh . | awk '{print "Figures directory: " $1}'
echo ""
