import ModalFunctionality from 'discourse/mixins/modal-functionality';

export default Ember.Controller.extend(ModalFunctionality, {

  actions: {
    applyIsShared() {
      this.get("model").saveChanges("is_shared");
      console.log(this.get('model.is_shared'));
    }
  }
});
