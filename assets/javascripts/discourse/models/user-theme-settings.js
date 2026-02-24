import ThemeSettings from "discourse/admin/models/theme-settings";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class UserThemeSettings extends ThemeSettings {
  loadMetadata(themeId) {
    return ajax(
      `/user_themes/${themeId}/objects_setting_metadata/${this.setting}.json`
    )
      .then((result) => this.set("metadata", result))
      .catch(popupAjaxError);
  }

  updateSetting(themeId, newValue) {
    if (this.objects_schema) {
      newValue = JSON.stringify(newValue);
    }

    return ajax(`/user_themes/${themeId}/setting`, {
      type: "PUT",
      data: {
        name: this.setting,
        value: newValue,
      },
    });
  }
}
