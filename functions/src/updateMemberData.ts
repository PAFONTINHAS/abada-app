import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

const db = admin.firestore();

export const updateMemberData = functions.firestore
  .document("users/{userId}")
  .onUpdate(async (document, context) => {
    try {
      const userId = context.params.userId;
      const before = document.before.data();
      const after = document.after.data();


      if (!before || !after) {
        console.log("Dados ausentes, nada a fazer");
        return null;
      }

      const attendedClasses: string[] = Array.isArray(before.attendedClasses) ?
        before.attendedClasses :
        before.attendedClasses ?
          [before.attendedClasses] :
          [];

      const classId = attendedClasses[0];

      // Validação defensiva: impede a chamada com caminho inválido/vazio
      if (!classId || typeof classId !== "string" || classId.trim() === "") {
        console.log("Nenhum ID de aula válido encontrado em attendedClasses");
        return null;
      }

      const hasBeltChanged = before.belt !== after.belt;
      const hasNicknameChanged = before.nickname !== after.nickname;
      const hasDisplaySensitiveDataChanged =
        before.displaySensitiveData !== after.displaySensitiveData;

      if (
        !hasBeltChanged &&
        !hasNicknameChanged &&
        !hasDisplaySensitiveDataChanged
      ) {
        console.log("Nenhuma mudança relevante capturada");
        return null;
      }

      const classDocument = db
        .collection("classes")
        .doc(attendedClasses[0])
        .collection("students").doc(userId);

      const belt = after.belt;
      let name = after.fullName;
      let userNickname = after.nickname;
      const displaySensitiveData : boolean = after.displaySensitiveData;

      if (!displaySensitiveData) {
        userNickname = null;
        name = null;
      }

      await classDocument.update({
        belt: belt,
        name: name,
        nickname: userNickname,
        displaySensitiveData: displaySensitiveData,
      });

      console.log("Dados atualizados com sucesso");
    } catch (error) {
      console.error("Erro ao realizar o update:", error);
    }

    return null;
  });
