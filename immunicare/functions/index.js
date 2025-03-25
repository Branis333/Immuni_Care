const functions = require("firebase-functions");
const Twilio = require("twilio");

// Twilio Credentials (Get from Twilio Console)
const accountSid = "AC491347ffbf5ae81428e16fb8b71eb90d";
const authToken = "10ae126cf3580be47159a1ea32658dfe";
const twilioNumber = "+12546004142";

// Initialize Twilio client
const client = new twilio(accountSid, authToken);

// Cloud Function to send SMS
exports.sendSMS = functions.https.onCall(async (data, context) => {
  const { phone, message } = data;

  try {
    const response = await client.messages.create({
      body: message,
      from: twilioNumber,
      to: phone,
    });

    return { success: true, sid: response.sid };
  } catch (error) {
    return { success: false, error: error.message };
  }
});
