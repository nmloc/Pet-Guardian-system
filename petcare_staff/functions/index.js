// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const functions = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.assignOrderToStaff = onDocumentCreated().document('order/{orderId}').onCreate(async (snapshot, context) => {
    // Find a staff with the same branchId and is not currently on task
    const staffQuerySnapshot = await db.collection('staff')
    .where('branchId', '==', snapshot.branchId)
    .where('onTask', '==', '')
    .limit(1)
    .get();

    if (staffQuerySnapshot.empty) {
        await db.collection('task queue').doc(snapshot.id).set({
            dateRequired: snapshot.dateRequired
            // Add other relevant data from the order
        });
    } else {
        // Assign the order to the staff
        await db.collection('order').doc(snapshot.id).update({
            staffId: staffsQuerySnapshot.docs[0].id,
            // You can add more fields to update here if needed
        });

        // Update the staff's onTask attribute
        await db.collection('staff').doc(staffsQuerySnapshot.docs[0].id).update({
            onTask: snapshot.id,
            // You can add more fields to update here if needed
        });
    }

    console.log(`Order ${snapshot.id} assigned to staff ${staffId}.`);
});
