import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

const db = admin.firestore();

export const activateEvent = functions.https.onCall(
  async (eventId: string, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Apenas usuários autenticados podem aprovar membros.",
      );
    }

    try {
      const eventReference = db.collection("ongoing_events").doc(eventId);

      await eventReference.update({eventActive: true});

      return {success: true};
    } catch (error) {
      console.error("Erro ao realizar o batch commit:", error);
      throw new functions.https.HttpsError(
        "aborted",
        `Erro ao processar solicitação: ${error}`,
      );
    }
  },
);
