require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const AWS = require('aws-sdk');

const app = express();
const port = process.env.PORT || 3000;

// AWS setup
AWS.config.update({ region: process.env.AWS_REGION || 'us-east-1' });
const dynamodb = new AWS.DynamoDB.DocumentClient();
const tableName = 'bootcamp-4-us-east-1-dev-table';

app.use(bodyParser.urlencoded({ extended: true }));

// HTML page with form and table of users
app.get('/', async (req, res) => {
  let usersHtml = '';

  try {
    const data = await dynamodb.scan({ TableName: tableName }).promise();
    const items = data.Items || [];

    usersHtml = `
      <h3>Saved Users</h3>
      <table border="1" cellpadding="5" cellspacing="0">
        <tr><th>First Name</th><th>Last Name</th></tr>
        ${items.map(user => `<tr><td>${user.firstName}</td><td>${user.lastName}</td></tr>`).join('')}
      </table>
    `;
  } catch (err) {
    console.error("Error fetching users:", err);
    usersHtml = `<p style="color:red;">Failed to load users</p>`;
  }

  res.send(`
    <h2>User Form</h2>
    <form action="/submit" method="POST">
      <input type="text" name="firstName" placeholder="First Name" required /><br/><br/>
      <input type="text" name="lastName" placeholder="Last Name" required /><br/><br/>
      <button type="submit">Submit</button>
    </form>
    <hr />
    ${usersHtml}
  `);
});

// Submit form
app.post('/submit', async (req, res) => {
  const { firstName, lastName } = req.body;

  const params = {
    TableName: tableName,
    Item: {
      userId: `${Date.now()}`,
      firstName,
      lastName
    }
  };

  try {
    await dynamodb.put(params).promise();
    res.redirect('/');
  } catch (err) {
    console.error('Error saving data:', err);
    res.status(500).send("Error saving data.");
  }
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running at http://0.0.0.0:${port}`);
});

