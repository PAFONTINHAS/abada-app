import * as admin from "firebase-admin";

admin.initializeApp();

export {approveMemberRequestAndAddToClass}
  from "./approveMemberRequestAndAddToClass";

export {updateProfessorLecturedClasses}
  from "./updateProfessorLecturedClasses";

export {removeProfessorLecturedClasses}
  from "./removeProfessorLecturedClasses";
