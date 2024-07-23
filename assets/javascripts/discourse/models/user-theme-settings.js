import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import ThemeSettings from "admin/models/theme-settings";

export default class UserThemeSettings extends ThemeSettings {
  loadMetadata(themeId) {
    return ajax(
      `/user_themes/${themeId}/objects_setting_metadata/${this.setting}.json`
    )
      .then((result) => this.set("metadata", result))
      .catch(popupAjaxError);
  }
}
