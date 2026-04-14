#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

/**
 * Weekly update script
 * - Generates current timestamp
 * - Updates lastmod field in content/music.md

 */

async function updateMusic() {
  try {
    // Generate current timestamp in ISO format
    const timestamp = new Date().toISOString();
    
    // Path to music.md
    const musicPath = path.join(__dirname, '../content/music.md');
    
    // Read the file
    let content = fs.readFileSync(musicPath, 'utf8');
    
    // Split front matter from content
    const parts = content.split('---');
    if (parts.length < 3) {
      throw new Error('Invalid front matter format in music.md');
    }
    
    // Parse YAML front matter
    const frontMatter = yaml.load(parts[1]);
    
    // Update lastmod timestamp
    frontMatter.lastmod = timestamp;
    
    // Reconstruct the file with updated front matter
    const updatedContent = `---\n${yaml.dump(frontMatter)}---\n${parts.slice(2).join('---')}`;
    
    // Write back to file
    fs.writeFileSync(musicPath, updatedContent, 'utf8');
    
    console.log(`✓ Updated music.md with timestamp: ${timestamp}`);
    console.log(`✓ Commit message: "Update music (automated weekly update)"`);
    
    return {
      success: true,
      timestamp,
      commitMessage: 'Update music (automated weekly update)'
    };
  } catch (error) {
    console.error('✗ Error updating music.md:', error.message);
    process.exit(1);
  }
}

// Run the update
updateMusic();
