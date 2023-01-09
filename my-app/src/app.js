const express = require('express');
const app = express();
const port = 5000;

app.get('/', function (req, res) {
  res.send('Hello World');
});

app.listen(port);

console.log(`Environment is "${process.env.NODE_ENV}".`);
console.log(`Server is listening to port ${port}.`);
console.log(`You can access the API by connecting to http://localhost:${port}.`);
