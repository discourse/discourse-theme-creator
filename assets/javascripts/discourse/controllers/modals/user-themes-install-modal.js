import AdminInstallTheme from "admin/controllers/modals/admin-install-theme";
import { inject as controller } from "@ember/controller";

export default class UserThemeInstallModal extends AdminInstallTheme {
  @controller("user.themes") adminCustomizeThemes;
  @controller("user.themes") themesController;
  keyGenUrl = "/user_themes/generate_key_pair";
  importUrl = "/user_themes/import";
  selection = "create";
  recordType = "user-theme";
}
