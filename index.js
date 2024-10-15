const express = require('express');
const bodyParser = require('body-parser');
const { exec } = require('child_process');

const app = express();
app.use(bodyParser.json());

app.post('/webhook', (req, res) => {
    console.log('Received webhook:', req.body);
    
    // Execute your script or Docker command
    exec('/usr/local/bin/deploy 2', (error, stdout, stderr) => {
        if (error) {
            console.error(`Error executing script: ${error}`);
            return res.status(500).send(`Script execution failed: ${error}`);
        }
        console.log(`Script output: ${stdout}`);
        res.status(200).send(`Webhook received and script executed ${stdout}`);
    });
});

const PORT = 5002;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
