import I18n from "I18n";
import DiscourseRoute from "discourse/routes/discourse";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default class extends DiscourseRoute {
  @service dialog;
  templateName = "adminCustomizeThemesEdit";

  model(params) {
    const all = this.modelFor("user.themes");
    const model = all.findBy("id", parseInt(params.theme_id, 10));
    return model
      ? {
          model,
          target: params.target,
          field_name: params.field_name,
        }
      : this.replaceWith("user.themes.index");
  }

  serialize(wrapper) {
    return {
      model: wrapper.model,
      target: wrapper.target || "common",
      field_name: wrapper.field_name || "scss",
      theme_id: wrapper.model.get("id"),
    };
  }

  setupController(controller, wrapper) {
    const fields = wrapper.model
      .get("fields")
      [wrapper.target].map((f) => f.name);
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
  }

  @action
  willTransition(transition) {
    if (
      this.get("controller.model.changed") &&
      this.get("shouldAlertUnsavedChanges") &&
      transition.intent.name !== this.routeName
    ) {
      transition.abort();

      this.dialog.confirm({
        message: I18n.t("admin.customize.theme.unsaved_changes_alert"),
        confirmButtonLabel: "admin.customize.theme.discard",
        cancelButtonLabel: "admin.customize.theme.stay",
        didConfirm: () => {
          this.set("shouldAlertUnsavedChanges", false);
          transition.retry();
        },
      });
    }
  }
}
