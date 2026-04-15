#!/usr/bin/env node

require('dotenv').config();

const fs = require('fs');
const path = require('path');

/**
 * Weekly update script
 * - Fetches music data from last.fm API
 * - Stores data in assets/music-data.json
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
    
    // 2. Store generation timestamp on the saved JSON data
    musicData.generatedAt = timestamp;
    
    // 3. Save to JSON file
    const outputPath = path.join(__dirname, '../assets/music-data.json');
    fs.writeFileSync(outputPath, JSON.stringify(musicData, null, 2), 'utf8');
    console.log(`✓ Saved music data to ${outputPath}`);
    
    return {
      success: true,
    };
  } catch (error) {
    console.error('✗ Error during music update:', error.message);
    process.exit(1);
  }
}

// Run the update
updateMusic();

