import AdminImportTheme from "admin/controllers/modals/admin-import-theme";

export default AdminImportTheme.extend({
  adminCustomizeThemes: Ember.inject.controller("user.themes"),
  keyGenUrl: "/user_themes/generate_key_pair",
  importUrl: "/user_themes/import"
});
