import ThemeSettingEditor from "discourse/admin/components/theme-setting-editor";
import JsonSchemaEditorModal from "discourse/components/modal/json-schema-editor";

export default class UserThemeSettingEditor extends ThemeSettingEditor {
  get settingEditButton() {
    const setting = this.setting;
    if (setting.json_schema) {
      return {
        action: () => {
          this.modal.show(JsonSchemaEditorModal, {
            model: {
              updateValue: (value) => {
                this.buffered.set("value", value);
              },
              value: this.buffered.get("value"),
              settingName: setting.setting,
              jsonSchema: setting.json_schema,
            },
          });
        },
        label: "admin.site_settings.json_schema.edit",
        icon: "pencil",
      };
    } else if (setting.objects_schema) {
      return {
        action: () => {
          this.router.transitionTo(
            "user.themes.show.schema",
            this.args.model.id,
            setting.setting
          );
        },
        label: "admin.customize.theme.edit_objects_theme_setting",
        icon: "pencil",
      };
    }
    return null;
  }
}
