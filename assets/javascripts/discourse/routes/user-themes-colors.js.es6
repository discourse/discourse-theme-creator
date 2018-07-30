export default Ember.Route.extend({
  serialize(model) {
    return {
      theme_id: model.get("theme_id"),
      id: model.get("id")
    };
  },

  model(params) {
    const schemes = this.modelFor("user.themes").get("colorSchemes");

    const model = schemes.findBy("id", parseInt(params.color_scheme_id));

    if (!model || model.theme_id !== parseInt(params.theme_id)) {
      this.replaceWith("user.themes.index");
    }

    return model;
  }
});
