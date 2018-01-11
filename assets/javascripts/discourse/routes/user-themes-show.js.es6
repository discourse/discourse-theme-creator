
export default Ember.Route.extend({

  serialize(model) {
    return {theme_id: model.get('id')};
  },

  model(params) {
    const all = this.modelFor('user.themes');
    const model = all.findBy('id', parseInt(params.theme_id));
    return model ?  model : this.replaceWith('user.themes.index');
  },

  setupController(controller, model) {
    controller.set("model", model);
    const parentController = this.controllerFor("user.themes");
    parentController.set("editingTheme", false);
    controller.set("allThemes", parentController.get("model"));
    controller.set("colorSchemes", parentController.get("model.extras.color_schemes"));
    controller.set("colorSchemeId", model.get("color_scheme_id"));
  },

});
