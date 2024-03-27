/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// app id - 8adade7c65554a28907be8616ffaba5e
// certificate - adc93ee71c3c4cffa4a40ae646e87c25
// default uncommented 2lines of code
// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");


// -----------bing -- from which i asked updated video_call.dart code-----
const functions = require("firebase-functions");
const Agora = require("agora-access-token");

exports.tokenGeneration = functions.https.onRequest((request, response) => {
  const appID = "8adade7c65554a28907be8616ffaba5e";
  const appCertificate = "adc93ee71c3c4cffa4a40ae646e87c25";
  const channel = request.body.channelName;
  const uid = request.body.uid;
  const role = request.body.role == 0 ? Agora.RtcRole.PUBLISHER :
   Agora.RtcRole.SUBSCRIBER;
  const expirationTimestamp = Math.floor(Date.now() / 1000) + 3600;

  const token = Agora.RtcTokenBuilder.buildTokenWithUid(appID,
      appCertificate, channel, uid, role, expirationTimestamp);

  response.send({"token": token});
});


// -----------------gpt---------------------
/*
const functions = require('firebase-functions');
const agoraToken = require('agora-access-token');

exports.generateAgoraToken = functions.https.onRequest((req, res) => {
  const appId = '8adade7c65554a28907be8616ffaba5e';
  const appCertificate = 'adc93ee71c3c4cffa4a40ae646e87c25';
  const channelName = req.query.channelName;
  const uid = req.query.uid;

  const token = agoraToken.RtcTokenBuilder.buildTokenWithUid(appId,
     appCertificate, channelName, uid, agoraToken.RtcRole.PUBLISHER, 3600);

  res.send(token);
});
*/

// ---------bing-------------------
/*
const functions = require('firebase-functions');
const {RtcTokenBuilder, RtcRole} = require('agora-access-token');

exports.generateAgoraToken = functions.https.onCall((data, context) => {
  const appID = 'your-agora-app-id';
  const appCertificate = 'your-agora-app-certificate';
  const channelName = data.channelName;
  const uid = data.uid;
  const role = RtcRole.PUBLISHER;
  const expirationTimeInSeconds = 3600;
  const currentTimestamp = Math.floor(Date.now() / 1000);
  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

  return RtcTokenBuilder.buildTokenWithUid(appID, appCertificate,
    channelName, uid, role, privilegeExpiredTs);
});
*/


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
