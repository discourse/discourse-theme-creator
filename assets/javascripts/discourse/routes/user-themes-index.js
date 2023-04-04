import AdminCustomizeThemesIndex from "admin/routes/admin-customize-themes-index";

export default class UserThemesIndex extends AdminCustomizeThemesIndex {
  templateName = "adminCustomizeThemesIndex";

  setupController() {
    super.setupController(...arguments);
    const parentController = this.controllerFor("user.themes");
    parentController.set("editingTheme", false);
  }
}
