export default Ember.Component.extend({
  tagName: "div",
  classNames: "metadata-field",
  actions: {
    startEditing() {
      this.set("oldValue", this.get("value"));
      this.set("editing", true);
    },
    cancelEditing() {
      this.set("value", this.get("oldValue"));
      this.set("editing", false);
    },
    finishedEditing() {
      this.save().then(() => {
        this.set("editing", false);
      });
    }
  }
});
