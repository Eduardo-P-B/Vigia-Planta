require('dotenv').config({ quiet: true });
const mysql = require('mysql2');

const conexao = mysql.createConnection({
  host: '143.106.241.4',
  port: 3306,
  user: 'cl205238',
  password: 'cl*03012008',
  database: 'cl205238'
});

module.exports = conexao;