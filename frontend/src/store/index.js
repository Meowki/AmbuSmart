import { createStore } from "vuex";

export default createStore({
  state: {
    operation_id: null,
    patient_id: null,
  },
  mutations: {
    setOperationId(state, operation_id) {
      state.operation_id = operation_id;
    },
    setPatientId(state, patient_id) {
      state.patient_id = patient_id;
    },
  },
});
