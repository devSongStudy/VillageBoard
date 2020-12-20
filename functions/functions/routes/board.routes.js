const { Router } = require('express');
const router = Router();

const admin = require('firebase-admin');
const db = admin.firestore();

router.post('/normal', async (req, res) => {
    try {
        const title = req.body.title;
        if (!title) throw new Error("title is null");

        const discription = req.body.discription;
        if (!discription) throw new Error("discription is null");

        const createdAt = admin.firestore.Timestamp.now().seconds;

        await db.collection("BOARDS")
            .doc("Normal")
            .collection("Articles")
            .doc("/" + createdAt + "/")
            .set({
                title: title,
                discription: discription,
                createdAt: createdAt,
            });

        return res.json({resCode: 0, resMessage:"Success"});

    } catch (err) {
        console.log("Error: ", err);
        return res.json({resCode: 9999, resMessage: "정의되지 않은 에러"});
    }
});

router.put('/normal', async (req, res) => {
    try {
        const title = req.body.title;
        if (!title) throw new Error("title is null");

        const discription = req.body.discription;
        if (!discription) throw new Error("discription is null");

        const createdAt = req.body.createdAt;
        if (!createdAt) throw new Error("createdAt is null");

        const updatedAt = admin.firestore.Timestamp.now().seconds;

        await db.collection("BOARDS")
            .doc("Normal")
            .collection("Articles")
            .doc("/" + createdAt + "/")
            .set({
                title: title,
                discription: discription,
                createdAt: createdAt,
                updatedAt: updatedAt,
            });

        return res.json({resCode: 0, resMessage:"Success"});

    } catch (err) {
        console.log("Error: ", err);
        return res.json({resCode: 9999, resMessage: "정의되지 않은 에러"});
    }
});

router.get('/normal', async (req, res) => {
    try {
        let {startAfter = 0, limit = 10} = req.query;
        startAfter = parseInt(startAfter);
        var docRef = db.collection("BOARDS").doc("Normal").collection("Articles").orderBy("createdAt", "desc")
        if (startAfter > 0) {
            docRef = docRef.startAfter(startAfter);
        }
        docRef.limit(parseInt(limit)).get().then(snapshot => {
            var articles = [];
            snapshot.forEach((doc) => {
                articles.push(doc.data());
            });
            return res.json({
                resCode: 0,
                resData: { articles: articles }
            });

        }).catch(err => {
            console.log(err);
            return res.json({resCode: 1000, resMessage: "DB Get failed"});
        });

    } catch (err) {
        console.log("Error: ", err);
        return res.json({resCode: 9999, resMessage: "정의되지 않은 에러"});
    }
});

router.delete('/normal/:createdAt', async (req, res) => {
    try {
        const createdAt = req.params.createdAt;
        if (!createdAt) throw new Error("createdAt is null");

        await db.collection("BOARDS")
            .doc("Normal")
            .collection("Articles")
            .doc("/" + createdAt + "/")
            .delete();

        return res.json({resCode: 0, resMessage:"Success"});

    } catch (err) {
        console.log("Error: ", err);
        return res.json({resCode: 9999, resMessage: "정의되지 않은 에러"});
    }
});

module.exports = router;