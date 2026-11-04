import {abadaBelts} from "./common";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";
import {FieldValue, Timestamp} from "firebase-admin/firestore";

const db = admin.firestore();

export const finishEventsAndGraduateMembers = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "512MB",
  })
  .pubsub.schedule("0 * * * *")
  .timeZone("America/Sao_Paulo")
  .onRun(async () => {
    console.log("Função acionada");

    const agora = new Date();
    const agoraTimestamp = Timestamp.fromDate(agora);

    try {
      const finishedEvents = await db
        .collection("ongoing_events")
        .where("eventActive", "==", true)
        .where("eventEndingDate", "<=", agoraTimestamp)
        .get();

      if (finishedEvents.empty) {
        console.log("Nenhum evento vencido");
        return null;
      }

      console.log(`Encontrados ${finishedEvents.size} eventos para processar`);

      const promises = finishedEvents.docs.map(async (eventDoc) => {
        const finishedEventsRef = db
          .collection("finished_events")
          .doc(eventDoc.id);
        const eventSubscriptionRef =
          finishedEventsRef.collection("subscriptions");

        const eventSubscriptionsSnap = await db
          .collection("ongoing_events_subscriptions")
          .where("eventId", "==", eventDoc.id)
          .get();

        const event = eventDoc.data();

        if (!event) return;

        const batch = db.batch();

        batch.set(finishedEventsRef, {
          ...event,
          eventActive: false,
          finishedEvent: true,
          updatedAt: FieldValue.serverTimestamp(),
        });

        if (!eventSubscriptionsSnap.empty) {
          for (const subDoc of eventSubscriptionsSnap.docs) {
            const newSubDocRef = eventSubscriptionRef.doc(subDoc.id);

            await newSubDocRef.set(subDoc.data());
            await subDoc.ref.delete();
          }
        }

        batch.delete(eventDoc.ref);

        if (
          event.eventType === "GRADUATION" &&
          Array.isArray(event.selectedMembersId) &&
          event.selectedMembersId.length > 0
        ) {
          const userPromises = event.selectedMembersId.map(
            async (memberId: string) => {
              const userRef = db.collection("users").doc(memberId);
              const userDoc = await userRef.get();

              if (!userDoc.exists) return;

              const userData = userDoc.data();
              const currentBelt = userData?.belt;

              if (currentBelt) {
                const currentIndex = abadaBelts.findIndex(
                  (belt) =>
                    belt.belt.toUpperCase() === currentBelt.toUpperCase(),
                );

                if (
                  currentIndex !== -1 &&
                  currentIndex < abadaBelts.length - 1
                ) {
                  const nextBelt = abadaBelts[currentIndex + 1];
                  batch.update(userRef, {belt: nextBelt.belt});
                }
              }
            },
          );

          await Promise.all(userPromises);
        }

        await batch.commit();
      });

      await Promise.all(promises);

      console.log("Processamento concluído com sucesso");

      return null;
    } catch (error) {
      console.error("Erro: ", error);
      return null;
    }
  });
