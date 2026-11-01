import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";


const db = admin.firestore();

interface ClassRequestData {
  classId: string;
}

export const leaveClass = functions.https.onCall(
  async (classRequestData: ClassRequestData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Apenas usuários autenticados podem sair de uma turma.",
      );
    }

    const memberId = context.auth.uid;
    const memberReference = db.collection("users").doc(memberId);
    const classReference = db.collection("classes").doc(classRequestData.classId);
    const studentInClassRef = classReference.collection("students").doc(memberId);

    const [memberDoc, classDoc, studentInClassDoc] = await Promise.all([
      memberReference.get(),
      classReference.get(),
      studentInClassRef.get(),
    ]);

    if (!classDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "Turma não encontrada.",
      );
    }

    if (!studentInClassDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "Aluno não faz parte desta turma.",
      );
    }

    try {
      const batch = db.batch();
      const historyReference = classReference
        .collection("studentHistory")
        .doc();

      batch.set(historyReference, {
        ...studentInClassDoc.data(),
        studentId: memberId,
        exitedAt: FieldValue.serverTimestamp(),
      });
      batch.delete(studentInClassRef);

      if (memberDoc.exists) {
        batch.update(memberReference, {
          userRole: "unvalidatedUser",
          attendedClasses: FieldValue.arrayRemove(classRequestData.classId),
        });
      }

      await batch.commit();

      return {"success": true, "exitedAt": "serverTimestamp"};
    } catch (error) {
      console.error("Erro ao realizar o batch commit:", error);
      throw new functions.https.HttpsError(
        "aborted",
        `Erro ao processar solicitação: ${error}`,
      );
    }
  },
);
