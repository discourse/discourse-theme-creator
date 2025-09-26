import AdminCustomizeThemesIndex from "admin/routes/admin-config/customize/themes";

export default class UserThemesIndex extends AdminCustomizeThemesIndex {
  templateName = "adminCustomizeThemesIndex";

  beforeModel() {
    // override the redirect in core
  }

  setupController() {
    super.setupController(...arguments);
    const parentController = this.controllerFor("user.themes");
    parentController.set("editingTheme", false);
  }
}
