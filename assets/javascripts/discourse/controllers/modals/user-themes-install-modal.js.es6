import AdminInstallTheme from "admin/controllers/modals/admin-install-theme";

export default AdminInstallTheme.extend({
  adminCustomizeThemes: Ember.inject.controller("user.themes"),
  themesController: Ember.inject.controller("user.themes"),
  keyGenUrl: "/user_themes/generate_key_pair",
  importUrl: "/user_themes/import",
  selection: "create",
  recordType: "user-theme"
});
