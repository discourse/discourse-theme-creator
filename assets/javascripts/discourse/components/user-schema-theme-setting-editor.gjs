import { action } from "@ember/object";
import { popupAjaxError } from "discourse/lib/ajax-error";
import SchemaThemeSettingEditor from "admin/components/schema-setting/editor";

export default class UserSchemaThemeSettingEditor extends SchemaThemeSettingEditor {
  @action
  saveChanges() {
    this.saveButtonDisabled = true;

    this.args.setting
      .updateSetting(this.args.id, this.data)
      .then((result) => {
        this.args.setting.set("value", result[this.args.setting.setting]);

        this.router.transitionTo("user.themes.show", this.args.id);
      })
      .catch((e) => {
        if (e.jqXHR.responseJSON && e.jqXHR.responseJSON.errors) {
          this.validationErrorMessage = e.jqXHR.responseJSON.errors[0];
        } else {
          popupAjaxError(e);
        }
      })
      .finally(() => (this.saveButtonDisabled = false));
  }
}
