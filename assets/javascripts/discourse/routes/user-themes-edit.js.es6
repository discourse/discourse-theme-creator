import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  templateName: "adminCustomizeThemesEdit",

  model(params) {
    const all = this.modelFor("user.themes");
    const model = all.findBy("id", parseInt(params.theme_id, 10));
    return model
      ? {
          model,
          target: params.target,
          field_name: params.field_name
        }
      : this.replaceWith("user.themes.index");
  },

  serialize(wrapper) {
    return {
      model: wrapper.model,
      target: wrapper.target || "common",
      field_name: wrapper.field_name || "scss",
      theme_id: wrapper.model.get("id")
    };
  },

  setupController(controller, wrapper) {
    const fields = wrapper.model.get("fields")[wrapper.target].map(f => f.name);
    if (!fields.includes(wrapper.field_name)) {
      this.transitionTo(
        "user.themes.edit",
        wrapper.model.id,
        wrapper.target,
        fields[0]
      );
      return;
    }
    controller.set("model", wrapper.model);
    controller.setTargetName(wrapper.target || "common");
    controller.set("fieldName", wrapper.field_name || "scss");
    this.controllerFor("user.themes").set("editingTheme", true);
    this.set("shouldAlertUnsavedChanges", true);
  },

  actions: {
    willTransition(transition) {
      if (
        this.get("controller.model.changed") &&
        this.get("shouldAlertUnsavedChanges") &&
        transition.intent.name !== this.routeName
      ) {
        transition.abort();
        bootbox.confirm(
          I18n.t("admin.customize.theme.unsaved_changes_alert"),
          I18n.t("admin.customize.theme.discard"),
          I18n.t("admin.customize.theme.stay"),
          result => {
            if (!result) {
              this.set("shouldAlertUnsavedChanges", false);
              transition.retry();
            }
          }
        );
      }
    }
  }
});
