import AdminCustomizeThemesEdit from "discourse/admin/controllers/admin-customize-themes/edit";
import { url } from "discourse/lib/computed";

export default class UserThemesEdit extends AdminCustomizeThemesEdit {
  @url("model.id", "/user_themes/%@/preview") previewUrl;

  editRouteName = "user.themes.edit";
  showRouteName = "user.themes.show";
}
