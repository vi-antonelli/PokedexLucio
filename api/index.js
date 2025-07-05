
const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = 3000;

// PostgreSQL connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

app.use(express.json());

// Create tables if they don't exist
const createTables = async () => {
  const client = await pool.connect();
  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS usuarios (
        id SERIAL PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        senha TEXT NOT NULL
      );
    `);
    await client.query(`
      CREATE TABLE IF NOT EXISTS pokemons (
        id INTEGER PRIMARY KEY,
        nome TEXT,
        tipo TEXT,
        imagem TEXT
      );
    `);
  } finally {
    client.release();
  }
};

// API endpoints
app.get('/pokemons', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM pokemons');
    res.json(result.rows);
    client.release();
  } catch (err) {
    console.error(err);
    res.status(500).send('Error fetching pokemons');
  }
});

app.post('/login', async (req, res) => {
  const { email, senha } = req.body;
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM usuarios WHERE email = $1 AND senha = $2', [email, senha]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(401).send('Invalid credentials');
    }
    client.release();
  } catch (err) {
    console.error(err);
    res.status(500).send('Error logging in');
  }
});

app.listen(port, async () => {
  await createTables();
  console.log(`Server listening at http://localhost:${port}`);
});
