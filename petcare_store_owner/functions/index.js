const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {GoogleAuth} = require("google-auth-library");
const auth = new GoogleAuth();

admin.initializeApp();
const db = admin.firestore();

exports.assignOrderToStaff = functions.firestore.document("order/{orderId}")
    .onCreate(async (snapshot, context) => {
      const orderData = snapshot.data();
      // Find a staff with the same branchId and is not currently on task
      const staffQuerySnapshot = await db.collection("staff")
          .where("branchId", "==", orderData.branchId)
          .where("onTask", "==", "")
          .limit(1)
          .get();

      if (staffQuerySnapshot.empty) {
        await db.collection("task_queue").doc(snapshot.id).set({
          dateRequired: orderData.dateRequired,
          // Add other relevant data from the order
        });
      } else {
        // Assign the order to the staff
        await db.collection("order").doc(snapshot.id).update({
          staffId: staffQuerySnapshot.docs[0].id,
          // You can add more fields to update here if needed
        });

        // Update the staff"s onTask attribute
        await db.collection("staff").doc(staffQuerySnapshot.docs[0].id)
            .update({
              onTask: snapshot.id,
              // You can add more fields to update here if needed
            });
      }

      console.log(`Order ${snapshot.id} of customer ID: 
      ${orderData.petOwnerId} assigned to staff 
      ${staffQuerySnapshot.docs[0].id}.`);
    });

// exports.getCloudFunctionsToken = async function request() {
//   console.info(`request ${url} with target audience ${targetAudience}`);
//   const client = await auth.getIdTokenClient(targetAudience);

//   // Alternatively, one can use `client.idTokenProvider.fetchIdToken`
//   // to return the ID Token.
//   const res = await client.request({url});
//   console.info(res.data);
// }

// request().catch(err => {
//   console.error(err.message);
//   process.exitCode = 1;
// });

exports.getCloudFunctionsToken = functions.https.onCall(
    async (data, context) => {
      // Check if the user is authenticated
      if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated",
            "Request had no authentication token.");
      }

      try {
        const client = await auth.getIdTokenClient(data.targetAudience);

        // Use the client to fetch the ID token
        const idToken = await client.idTokenProvider.
            fetchIdToken(data.targetAudience);

        return {idToken: idToken};
      } catch (error) {
        console.error("Error fetching ID token:", error);
        throw new functions.https.HttpsError(
            "internal", "Error fetching ID token.");
      }
    });
