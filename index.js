const express = require('express');
const deployRouter = require('./routes/deploy');
const contractRouter = require('./routes/contract');
const cloudinaryRouter = require('./routes/cloudinary');
const metaDataRouter = require('./routes/metaData');
const connectDB = require('./db');
require('dotenv').config();
const cors = require('cors');

const app = express();
app.use(cors());

connectDB();

app.use(express.json());

app.use('/deploy', deployRouter);
app.use('/contract', contractRouter);
app.use('/cloudinary', cloudinaryRouter);
app.use('/metaData', metaDataRouter);

app.get('/', (req, res) => {
    res.send('Server is live 🎉🎉');
});

app.listen(7993, () => {
    console.log('Server is running on port 7993');
});
