import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";


const db = admin.firestore();

interface MemberRequestData {
  memberId: string;
  classId: string;
}

export const removeMemberFromClass = functions.https.onCall(
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

    const [memberDoc] = await Promise.all([
      memberReference.get(),
    ]);

    if (!memberDoc.exists) {
      console.error(`Usuário ${memberRequestData.memberId} não encontrado.`);
      throw new functions.https.HttpsError(
        "not-found",
        "Usuário não encontrado.",
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

      batch.delete(studentInClassRef);

      batch.update(memberReference, {
        userRole: "unvalidatedUser",
        attendedClasses: FieldValue.arrayRemove(memberRequestData.classId),
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
