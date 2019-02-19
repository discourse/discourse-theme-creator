import { default as computed } from "ember-addons/ember-computed-decorators";
import { url } from "discourse/lib/computed";
import AdminCustomizeThemesEdit from "admin/controllers/admin-customize-themes-edit";

export default AdminCustomizeThemesEdit.extend({
  previewUrl: url("model.id", "/user_themes/%@/preview"),

  editRouteName: "user.themes.edit",
  showRouteName: "user.themes.show"
});
