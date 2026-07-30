// .github/scripts/update_version_doc.js
const admin = require('firebase-admin');

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function updateVersionDoc() {
    await db.collection('app_config').doc('version').set({
        latestVersion: process.env.APP_VERSION,
        buildNumber: parseInt(process.env.BUILD_NUMBER, 10),
        apkUrl: process.env.APK_URL,
        mandatory: false,          // flip to true for must-update releases
        releasedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`Version doc updated: ${process.env.APP_VERSION}`);
}

updateVersionDoc().catch((err) => {
    console.error('Failed to update version doc:', err);
    process.exit(1);
});