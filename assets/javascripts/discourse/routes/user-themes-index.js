import AdminCustomizeThemesIndex from "admin/routes/admin-customize-themes-index";

export default AdminCustomizeThemesIndex.extend({
  templateName: "adminCustomizeThemesIndex",

  setupController() {
    this._super(...arguments);
    const parentController = this.controllerFor("user.themes");
    parentController.set("editingTheme", false);
  },
});
