#!/usr/bin/env node

require('dotenv').config();

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

/**
 * Weekly update script
 * - Fetches music data from last.fm API
 * - Stores data in assets/music-data.json
 * - Updates lastmod field in content/music.md
 * 
 * Environment variables required:
 * - LASTFM_USERNAME
 * - LASTFM_API_KEY
 */

async function fetchMusicData() {
  const username = process.env.LASTFM_USERNAME;
  const apiKey = process.env.LASTFM_API_KEY;

  if (!username || !apiKey) {
    throw new Error(
      'Missing environment variables. Please set LASTFM_USERNAME and LASTFM_API_KEY'
    );
  }

  const url = `http://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&period=1month&limit=5&format=json&user=${encodeURIComponent(username)}&api_key=${encodeURIComponent(apiKey)}`;

  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`Last.fm API error: ${response.status} ${response.statusText}`);
    }
    
    const data = await response.json();
    return data;
  } catch (error) {
    throw new Error(`Failed to fetch music data from last.fm: ${error.message}`);
  }
}

async function updateMusic() {
  try {
    // Generate current timestamp in ISO format
    const timestamp = new Date().toISOString();
    
    // 1. Fetch music data from API
    console.log('Fetching music data from last.fm API...');
    const musicData = await fetchMusicData();
    
    // 2. Save to JSON file
    const outputPath = path.join(__dirname, '../assets/music-data.json');
    fs.writeFileSync(outputPath, JSON.stringify(musicData, null, 2), 'utf8');
    console.log(`✓ Saved music data to ${outputPath}`);
    
    // 3. Update lastmod timestamp on music.md
    const musicPath = path.join(__dirname, '../content/music.md');
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
    console.error('✗ Error during music update:', error.message);
    process.exit(1);
  }
}

// Run the update
updateMusic();

