import {abadaBelts} from "./common";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";
import {FieldValue, Timestamp} from "firebase-admin/firestore";

const db = admin.firestore();

export const finishEventsAndGraduateMembers = functions.pubsub
  .schedule("0 * * * *")
  .timeZone("America/Sao_Paulo")
  .onRun(async () => {
    console.log("Função acionada");

    const agora = new Date();
    const agoraTimestamp = Timestamp.fromDate(agora);

    try {
      const query = db
        .collection("ongoing_events")
        .where("eventActive", "==", true)
        .where("eventEndingDate", "<=", agoraTimestamp);

      const snapshot = await query.get();

      if (snapshot.empty) {
        console.log("Nenhum evento vencido");
        return null;
      }

      console.log(`Encontrados ${snapshot.size} eventos para processar`);

      const promises = snapshot.docs.map(async (doc) => {
        const finshedEventsRef = db.collection("finished_events").doc();

        const event = doc.data();

        if (!event) return;

        const batch = db.batch();

        batch.set(finshedEventsRef, {
          ...event,
          eventActive: false,
          finishedEvent: true,
          updatedAt: FieldValue.serverTimestamp(),
        });

        batch.delete(doc.ref);

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

              const currentIndex = abadaBelts.findIndex(
                (belt) => belt.belt.toUpperCase() === currentBelt.toUpperCase(),
              );

              if (currentIndex !== -1 && currentIndex < abadaBelts.length - 1) {
                const nextBelt = abadaBelts[currentIndex + 1];
                batch.update(userRef, {belt: nextBelt.belt});
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
