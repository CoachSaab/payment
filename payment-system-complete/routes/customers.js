
const express = require('express');
const router = express.Router();
const Customer = require('../models/customer');


router.get('/', async (req, res) => {
    try {
        const customers = await Customer.find();
        res.send(customers);
    } catch (error) {
        res.status(500).send({ error: error.message });
    }
});

module.exports = router;
