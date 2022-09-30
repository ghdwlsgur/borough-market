const express = require('express');
const mongoosee = require('mongoose');

const app = express();

app.set('view engine', 'ejs');

app.use(express.urlencoded({ extended: false }));

mongoosee
    .connect(process.env.mongoURI, { useNewUrlParser: true })
    .then(() => console.log('MongoDB Connected'))
    .catch(err => console.log(err));

const { Item } = require('./models/Item');

app.get('/', (req, res) => {
    Item.find()
        .then(items => res.render('index', { items }))
        .catch(err => res.status(404).json({ msg: 'No items found ' }));
});

app.get('/status', (req, res) => {
    res.send('200');
});

app.post('/item/add', (req, res) => {
    const newItem = new Item({
        name: req.body.name,
    });

    newItem.save().then(item => res.redirect('/'));
});

const port = 3000;

app.listen(port, () => console.log('Server running...'));

module.exports = app;
