import { default as computed } from "ember-addons/ember-computed-decorators";
import AdminCustomizeThemesIndex from "admin/routes/admin-customize-themes-index";

export default AdminCustomizeThemesIndex.extend({
  templateName: "adminCustomizeThemesIndex",

  setupController(controller) {
    this._super(...arguments);
    const parentController = this.controllerFor("user.themes");
    parentController.set("editingTheme", false);
  }
});
