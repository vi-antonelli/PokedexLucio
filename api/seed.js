const { Pool } = require('pg');

const main = async () => {
  const { default: fetch } = await import('node-fetch');

  const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
  });

  const pokemonNames = [
    'blastoise',
    'bulbasaur',
    'caterpie',
    'charizard',
    'charmander',
    'charmeleon',
    'ivysaur',
    'squirtle',
    'venusaur',
    'wartortle',
  ];

  const seedDatabase = async () => {
    const client = await pool.connect();
    try {
      for (const name of pokemonNames) {
        const response = await fetch(`https://pokeapi.co/api/v2/pokemon/${name}`);
        const data = await response.json();

        const id = data.id;
        const types = data.types.map((typeInfo) => typeInfo.type.name).join(', ');
        const imageUrl = `/assets/images/${name}.png`;

        await client.query(
          'INSERT INTO pokemons (id, nome, tipo, imagem) VALUES ($1, $2, $3, $4) ON CONFLICT (id) DO NOTHING',
          [id, name, types, imageUrl]
        );
      }
      console.log('Database seeded successfully!');
    } catch (error) {
      console.error('Error seeding database:', error);
    } finally {
      client.release();
      pool.end();
    }
  };

  await seedDatabase();
};

main();