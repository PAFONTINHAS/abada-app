import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

const db = admin.firestore();

interface MemberRequestData {
  memberId: string;
  classId: string;
}

export const approveMemberRequestAndAddToClass = functions.https.onCall(
  async (memberRequestData: MemberRequestData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Apenas usuários autenticados podem aprovar membros.",
      );
    }

    const memberReference = db
      .collection("users")
      .doc(memberRequestData.memberId);

    const classReference = db
      .collection("classes")
      .doc(memberRequestData.classId);

    const studentInClassRef = classReference
      .collection("students")
      .doc(memberRequestData.memberId);

    const [memberDoc, classDoc, studentInClassDoc] = await Promise.all([
      memberReference.get(),
      classReference.get(),
      studentInClassRef.get(),
    ]);

    if (!memberDoc.exists) {
      console.error(`Utilizador ${memberRequestData.memberId} não encontrado.`);
      throw new functions.https.HttpsError(
        "not-found",
        "Utilizador não encontrado.",
      );
    }

    if (!classDoc.exists) {
      console.error(`Turma ${memberRequestData.classId} não encontrada.`);
      throw new functions.https.HttpsError(
        "not-found",
        "Turma não encontrada.",
      );
    }

    if (studentInClassDoc.exists) {
      throw new functions.https.HttpsError(
        "already-exists",
        "Membro já faz parte da turma",
      );
    }

    const memberData = memberDoc.data();

    if (!memberData) {
      throw new functions.https.HttpsError(
        "internal",
        "Erro ao aceder aos dados do utilizador.",
      );
    }

    try {
      const batch = db.batch();

      batch.set(studentInClassRef, {
        belt: memberData.belt,
        name: memberData.fullName,
        nickname: memberData.nickname,
        displaySensitiveData: true,
      });

      batch.update(memberReference, {
        userRole: "student",
      });

      await batch.commit();

      return {"success": true};
    } catch (error) {
      console.error("Erro ao realizar o batch commit:", error);
      throw new functions.https.HttpsError(
        "aborted",
        `Erro ao processar solicitação: ${error}`,
      );
    }
  },
);
