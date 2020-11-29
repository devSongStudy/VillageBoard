const { Router } = require('express');
const router = Router();

const admin = require('firebase-admin');
const db = admin.firestore();

router.post('/normal', async (req, res) => {
    return res.json({resCode: 0, resMessage:"success"});
});

module.exports = router;