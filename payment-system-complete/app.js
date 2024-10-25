const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

mongoose.connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
.then(() => console.log('MongoDB connected'))
.catch((err) => console.error('MongoDB connection error:', err));

const customerSchema = new mongoose.Schema({
    refNumber: String,
    name: String,
    amount: Number,
    dueDate: String,
    paid: Number,
    dueMonth: Number
});

const Customer = mongoose.model('Customer', customerSchema);

const customers = [
    { refNumber: "1234", name: "Mano", amount: 2500, dueDate: "25-10-2024", paidAmount: 2400, dueMonth: 7 },
    { refNumber: "1235", name: "Kaushik", amount: 5000, dueDate: "20-10-2024", paidAmount: 4500, dueMonth: 5 },
    { refNumber: "1236", name: "Nithin", amount: 4000, dueDate: "25-10-2024", paidAmount: 4000, dueMonth: 6 },
    { refNumber: "1237", name: "Roy", amount: 2500, dueDate: "19-10-2024", paidAmount: 2000, dueMonth: 3 }
];

app.get('/api/customers', (req, res) => {
    res.json(customers);
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
