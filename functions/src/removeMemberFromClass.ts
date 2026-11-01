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
        "Apenas usuários autenticados podem remover membros.",
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

    if (!classDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "Turma não encontrada.",
      );
    }

    const classData = classDoc.data();
    if (classData?.professor?.professorId !== context.auth.uid) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Apenas o professor da turma pode remover alunos.",
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
        studentId: memberRequestData.memberId,
        exitedAt: FieldValue.serverTimestamp(),
      });
      batch.delete(studentInClassRef);

      if (memberDoc.exists) {
        batch.update(memberReference, {
          userRole: "unvalidatedUser",
          attendedClasses: FieldValue.arrayRemove(memberRequestData.classId),
        });
      } else {
        console.warn(
          `Usuário ${memberRequestData.memberId} não encontrado; ` +
          "removendo apenas o vínculo órfão da turma.",
        );
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
