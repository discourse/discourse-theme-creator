import { action } from "@ember/object";
import { service } from "@ember/service";
import DiscourseRoute from "discourse/routes/discourse";
import { i18n } from "discourse-i18n";

export default class extends DiscourseRoute {
  @service dialog;
  @service router;

  templateName = "admin-customize-themes/edit";

  model(params) {
    const all = this.modelFor("user.themes");
    const model = all.findBy("id", parseInt(params.theme_id, 10));
    return model
      ? {
          model,
          target: params.target,
          field_name: params.field_name,
        }
      : this.router.replaceWith("user.themes.index");
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
      this.router.transitionTo(
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
        message: i18n("admin.customize.theme.unsaved_changes_alert"),
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
