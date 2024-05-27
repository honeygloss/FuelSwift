import express from 'express';
import fetch from 'node-fetch';
import dotenv from 'dotenv';
import cors from 'cors';

dotenv.config();

const app = express();
const port = 3000;

// Enable CORS for all routes
app.use(cors());

// Define your API endpoint
app.get('/maps-api', async (req, res) => {
    const apiKey = process.env.GOOGLE_API_KEY;
    const apiUrl = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&libraries=places&callback=initMap`;

    try {
        const response = await fetch(apiUrl);
        const data = await response.text();
        res.send(data);
    } catch (error) {
        console.error('Error fetching Google Maps API:', error);
        res.status(500).send('Failed to fetch Google Maps API');
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Proxy server running on http://localhost:${port}`);
});
