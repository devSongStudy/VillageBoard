const functions = require('firebase-functions');
const admin = require('firebase-admin');

const express = require('express');
const cors = require('cors');

/* Local TEST
var serviceAccount = require("../serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://villageboard-74c6b.firebaseio.com"
});
/*/
admin.initializeApp({
    credential: admin.credential.applicationDefault()
});
//*/

const board = express();
board.use(cors({ origin: true }));
board.use(require("./routes/board.routes"));
exports.board = functions.https.onRequest(board);
