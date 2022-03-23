import AdminInstallTheme from "admin/controllers/modals/admin-install-theme";
import { inject as controller } from "@ember/controller";

export default AdminInstallTheme.extend({
  adminCustomizeThemes: controller("user.themes"),
  themesController: controller("user.themes"),
  keyGenUrl: "/user_themes/generate_key_pair",
  importUrl: "/user_themes/import",
  selection: "create",
  recordType: "user-theme",
});
