const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());
app.use(cors());

// Create 'uploads' folder if it does not exist
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir);
}

// Configure Multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadsDir);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});
const upload = multer({ storage: storage });

// MySQL connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // Replace with your MySQL username
  password: '', // Replace with your MySQL password
  database: 'diary_app',
});

db.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL');
});

// Create a new diary entry
app.post('/entries', upload.single('image'), (req, res) => {
  const { text } = req.body;
  const image = req.file ? req.file.filename : null;
  const query = 'INSERT INTO entries (text, image) VALUES (?, ?)';
  db.query(query, [text, image], (err, result) => {
    if (err) {
      console.error('Error inserting entry:', err);
      res.status(500).send('Error inserting entry');
      return;
    }
    res.status(201).send({ id: result.insertId, text, image });
  });
});

// Get all diary entries
app.get('/entries', (req, res) => {
  const query = 'SELECT * FROM entries';
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching entries:', err);
      res.status(500).send('Error fetching entries');
      return;
    }
    res.status(200).send(results);
  });
});

// Update a diary entry
app.put('/entries/:id', (req, res) => {
  const { id } = req.params;
  const { text } = req.body;
  const query = 'UPDATE entries SET text = ? WHERE id = ?';
  db.query(query, [text, id], (err, result) => {
    if (err) {
      console.error('Error updating entry:', err);
      res.status(500).send('Error updating entry');
      return;
    }
    res.status(200).send({ id, text });
  });
});

// Delete a diary entry
app.delete('/entries/:id', (req, res) => {
  const { id } = req.params;
  const query = 'DELETE FROM entries WHERE id = ?';
  db.query(query, [id], (err, result) => {
    if (err) {
      console.error('Error deleting entry:', err);
      res.status(500).send('Error deleting entry');
      return;
    }
    res.status(200).send({ id });
  });
});

// Serve static files from 'uploads' directory
app.use('/uploads', express.static(uploadsDir));

// Start server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});