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

router.get('/normal', async (req, res) => {
    try {
        var startAfter = req.params.startAfter;
        if (!startAfter) { startAfter = 0; }

        var endBefore = req.params.endBefore;
        if (!endBefore) { endBefore = 0; }

        const docRef = db.collection("BOARDS").doc("Normal").collection("Articles")
                        .orderBy("createdAt", "asc").limit(100);
        docRef.get().then(snapshot => {
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

module.exports = router;