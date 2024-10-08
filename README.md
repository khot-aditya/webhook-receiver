# Minimal setup to deploy webhook

### 1. **Create a GitHub Webhook:**
   GitHub Webhooks can trigger an action on your EC2 instance when a push or merge event happens.

   - Go to your repository on GitHub.
   - Navigate to `Settings` -> `Webhooks` -> `Add webhook`.
   - In the `Payload URL` field, enter the URL of your EC2 instance where you will receive the webhook event (e.g., `http://<your-ec2-ip>/webhook`).
   - Set the `Content type` to `application/json`.
   - Select the event you want to trigger the webhook. For this case, choose `Push` or `Pull request merge`.
   - Save the webhook.

### 2. **Setup Webhook Receiver on EC2:**
   Install a simple HTTP server to listen to the webhook request and trigger your script or Docker container.

   - **Install Node.js and Express (for an easy setup):**
     ```bash
     sudo apt update
     sudo apt install nodejs npm -y
     mkdir webhook-server && cd webhook-server
     npm init -y
     npm install express body-parser
     ```

   - **Create a simple webhook server (`index.js`):**
     ```javascript
     const express = require('express');
     const bodyParser = require('body-parser');
     const { exec } = require('child_process');

     const app = express();
     app.use(bodyParser.json());

     app.post('/webhook', (req, res) => {
         console.log('Received webhook:', req.body);
         
         // Execute your script or Docker command
         exec('sh ./deploy.sh', (error, stdout, stderr) => {
             if (error) {
                 console.error(`Error executing script: ${error}`);
                 return res.status(500).send('Script execution failed');
             }
             console.log(`Script output: ${stdout}`);
             res.status(200).send('Webhook received and script executed');
         });
     });

     const PORT = process.env.PORT || 3000;
     app.listen(PORT, () => {
         console.log(`Server running on port ${PORT}`);
     });
     ```

   - **Create a sample script (`deploy.sh`):**
     ```bash
     #!/bin/bash
     echo "Webhook triggered script!"
     # docker pull your-docker-image
     # docker run -d your-docker-image
     ```

   - Make the script executable:
     ```bash
     chmod +x deploy.sh
     ```

### 3. **Run the Webhook Server:**
   Start the server:
   ```bash
   node index.js
   ```

   Ensure port 3000 is open in your EC2 instance security group to allow incoming traffic.

### 4. **Test the Webhook:**
   - Push or merge a PR to your GitHub repository.
   - The webhook should trigger, sending a request to your EC2 server, which in turn will execute the script or run a Docker container.

This minimal setup will allow you to trigger a script or Docker container upon a push or merge event in GitHub.