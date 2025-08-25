import { url } from "discourse/lib/computed";
import AdminCustomizeThemesEdit from "admin/controllers/admin-customize-themes-edit";

export default class UserThemesEdit extends AdminCustomizeThemesEdit {
  @url("model.id", "/user_themes/%@/preview") previewUrl;

  editRouteName = "user.themes.edit";
  showRouteName = "user.themes.show";
}
