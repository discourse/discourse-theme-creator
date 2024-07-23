import Theme from "admin/models/theme";
import UserThemeSettings from "./user-theme-settings";

export default class UserTheme extends Theme {
  static munge(json) {
    if (json.settings) {
      json.settings = json.settings.map((setting) =>
        UserThemeSettings.create(setting)
      );
    }

    return json;
  }
}
