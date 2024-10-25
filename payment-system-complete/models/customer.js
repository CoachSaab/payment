
const mongoose = require('mongoose');

const customerSchema = new mongoose.Schema({
    refNumber: { type: String, required: true },
    name: { type: String, required: true },
    amount: { type: Number, required: true },
    dueDate: { type: String, required: true },
    paidAmount: { type: Number, required: true },
    dueMonth: { type: Number, required: true }
});

module.exports = mongoose.model('Customer', customerSchema);
