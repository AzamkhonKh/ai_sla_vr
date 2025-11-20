#!/usr/bin/env node

/**
 * Direct Mermaid to PNG renderer using puppeteer
 * Renders all .mmd files in current directory to PNG format
 */

const fs = require('fs');
const path = require('path');
const { run } = require('@mermaid-js/mermaid-cli');

const figuresDir = __dirname;

// Find all .mmd files
const mmdFiles = fs.readdirSync(figuresDir)
  .filter(f => f.endsWith('.mmd'))
  .map(f => path.join(figuresDir, f));

console.log(`Found ${mmdFiles.length} Mermaid files to render`);

// Render each file
mmdFiles.forEach(async (inputFile) => {
  const outputFile = inputFile.replace('.mmd', '.png');
  console.log(`Rendering: ${path.basename(inputFile)} → ${path.basename(outputFile)}`);
  
  try {
    await run(
      inputFile,
      outputFile,
      {
        puppeteerConfig: {
          headless: 'new',
          args: ['--no-sandbox', '--disable-setuid-sandbox']
        },
        backgroundColor: 'white',
        width: 1920,
        height: 1080,
        scale: 2
      }
    );
    console.log(`✓ ${path.basename(outputFile)}`);
  } catch (error) {
    console.error(`✗ Failed: ${path.basename(inputFile)}`, error.message);
  }
});
