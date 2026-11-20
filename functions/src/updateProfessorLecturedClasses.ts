import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";

const db = admin.firestore();

export const updateProfessorLecturedClasses = functions.firestore
  .document("classes/{classId}")
  .onCreate(async (snapshot, context) => {
    try {
      const data = snapshot.data();

      const classId = context.params.classId;
      const professorId = data.professor.professorId;

      await db
        .collection("users")
        .doc(professorId)
        .update({
          lecturedClasses: FieldValue.arrayUnion(classId),
        });
    } catch (error) {
      console.error("Erro ao realizar o update:", error);
    }
  });
