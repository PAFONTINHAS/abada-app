import * as admin from "firebase-admin";

admin.initializeApp();

export {approveMemberRequestAndAddToClass}
  from "./approveMemberRequestAndAddToClass";

export {updateProfessorLecturedClasses}
  from "./updateProfessorLecturedClasses";

export {removeProfessorLecturedClasses}
  from "./removeProfessorLecturedClasses";

export {finishEventsAndGraduateMembers}
  from "./finishEventsAndGraduateMembers";

export {updateMemberData}
  from "./updateMemberData";

export {removeMemberFromClass}
  from "./removeMemberFromClass";


