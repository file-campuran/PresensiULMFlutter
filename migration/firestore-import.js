// Imports
const firestoreImport = require('node-firestore-import-export').firestoreImport
const firestoreData = require('./firestore-data.json')
const firebaseAdmin = require('firebase-admin')
const firebaseConfig = require('./config.js')
const serviceAccount = require('./serviceAccount.json')
const fs = require('fs');

const appConfig = {
    credential: firebaseAdmin.credential.cert(serviceAccount),
    databaseURL: firebaseConfig.databaseURL
}

const app = firebaseAdmin.initializeApp(appConfig)

// JSON To Firestore
const jsonToFirestore = async() => {
    for (const collectionName in firestoreData.__collections__) {
        const coll = firestoreData.__collections__[collectionName]
        for (const id in coll) {
            if (typeof coll[id].content == 'object') {
                fs.readFile(coll[id].content.path, 'utf8', async function(err, data) {
                    coll[id].content = data;

                    await importData(collectionName, {
                        [id]: coll[id]
                    });
                });

            } else {
                const data = {
                    [id]: coll[id]
                }
                await importData(collectionName, data);
            }
        }
    }
}

async function importData(collectionName, data) {
    const ref = app.firestore().collection(`${collectionName}`);
    await firestoreImport(data, ref)
        .then(() => {
            console.log('Firestore data successfully imported')
        }).catch((e) => {
            console.log(e ? e.message : e)
        })
    await new Promise((resolve) => {
        setTimeout(() => resolve(), 2000)
    });
}

jsonToFirestore()